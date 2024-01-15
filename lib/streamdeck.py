#!/usr/bin/env python3

import os
import subprocess
import threading
import pulsectl
import time
import sys
from functools import lru_cache

from enum import Enum
from PIL import Image, ImageDraw, ImageFont
from StreamDeck.DeviceManager import DeviceManager
from StreamDeck.ImageHelpers import PILHelper
from StreamDeck.Transport.Transport import TransportError
import copy

VOLUME_INCREMENT = 0.05

DEFAULTS = {
   'label': {
        # https://pillow.readthedocs.io/en/stable/reference/ImageFont.html
        'font': {
            'font': '/usr/share/fonts/TTF/Roboto-Regular.ttf',
            'size': 14,
        },
        # https://pillow.readthedocs.io/en/stable/reference/ImageDraw.html?highlight=text#PIL.ImageDraw.ImageDraw.text
        'text': {
            'xy': (36, 50),
            'anchor': 'ms',
            'fill': 'white',
            'text': None
        }
    },
    'image': None,
    'background': 'black',
}

# extend these

class Keys(Enum):
    MONITOR_DP1 = 0
    MONITOR_HDMI1 = 5
    MONITOR_HDMI2 = 10

    SPOTIFY_PREVIOUS = 6
    SPOTIFY_PLAYPAUSE = 7
    SPOTIFY_NEXT = 8
    SPOTIFY_VOLUME_UP = 4
    SPOTIFY_VOLUME_DOWN = 9

    CMUS_PREVIOUS = 11
    CMUS_PLAYPAUSE = 12
    CMUS_NEXT = 13

# Returns styling information for a key based on its position and state.
@lru_cache(None)
def get_key_style(key, state):
    info = copy.deepcopy(DEFAULTS)
    if key == Keys.SPOTIFY_PREVIOUS:
        info['label']['text']['text'] = 'Previous'
    elif key == Keys.SPOTIFY_PLAYPAUSE:
        info['label']['text']['text'] = 'Play/Pause'
    elif key == Keys.SPOTIFY_NEXT:
        info['label']['text']['text'] = 'Next'
    elif key == Keys.SPOTIFY_VOLUME_UP:
        info['label']['text']['text'] = 'Volume Up'
    elif key == Keys.SPOTIFY_VOLUME_DOWN:
        info['label']['text']['text'] = 'Volume Down'
    elif key == Keys.CMUS_PREVIOUS:
        info['label']['text']['text'] = 'Previous'
    elif key == Keys.CMUS_PLAYPAUSE:
        info['label']['text']['text'] = 'Play/Pause'
    elif key == Keys.CMUS_NEXT:
        info['label']['text']['text'] = 'Next'
    elif key == Keys.MONITOR_DP1:
        info['label']['text']['text'] = 'Desktop'
    elif key == Keys.MONITOR_HDMI1:
        info['label']['text']['text'] = 'Laptop'
    elif key == Keys.MONITOR_HDMI2:
        info['label']['text']['text'] = 'Other'

    # elif key == Keys.CMUS_VOLUME_UP:
    #     info['label']['text']['text'] = 'Volume Up'
    # elif key == Keys.CMUS_VOLUME_DOWN:
    #     info['label']['text']['text'] = 'Volume Down'
    return info

def key_change_callback(deck, key_num, state):
    key = key_num
    try:
        key = Keys(key_num)
    except ValueError:
        key = 'UNKNOWN'

    print(f'Deck {deck.id()} Key {key} / {key_num} = {state}', flush=True, file=sys.stderr)

    if not type(key) == Keys:
        return

    if state:
        if key == Keys.SPOTIFY_PREVIOUS:
            subprocess.run(['playerctl', '--player=spotify', 'previous'])
        elif key == Keys.SPOTIFY_PLAYPAUSE:
            subprocess.run(['playerctl', '--player=spotify', 'play-pause'])
        elif key == Keys.SPOTIFY_NEXT:
            subprocess.run(['playerctl', '--player=spotify', 'next'])
        elif key == Keys.CMUS_PREVIOUS:
            subprocess.run(['playerctl', '--player=cmus', 'previous'])
        elif key == Keys.CMUS_PLAYPAUSE:
            subprocess.run(['playerctl', '--player=cmus', 'play-pause'])
        elif key == Keys.CMUS_NEXT:
            subprocess.run(['playerctl', '--player=cmus', 'next'])
        elif key == Keys.SPOTIFY_VOLUME_UP:
            pulse_sink_input_volume('Spotify', increase=True)
        elif key == Keys.SPOTIFY_VOLUME_DOWN:
            pulse_sink_input_volume('Spotify', increase=False)
        # TODO, detect correct monitor instead of assuming monitor=2
        elif key == Keys.MONITOR_DP1:
            subprocess.run(['monitorcontrol', '--monitor=2', '--set-input-source=DP1'])
        elif key == Keys.MONITOR_HDMI1:
            subprocess.run(['monitorcontrol', '--monitor=2', '--set-input-source=HDMI1'])
        elif key == Keys.MONITOR_HDMI2:
            subprocess.run(['monitorcontrol', '--monitor=2', '--set-input-source=HDMI2'])
        else:
            raise NotImplementedError(key)


# this could probably be replaced with:
# pactl list short clients
# pactl set-sink-input-volume ID -10%
def pulse_sink_input_volume(app_name, increase=True):
    with pulsectl.Pulse('volume') as pulse:
        for sink in pulse.sink_input_list():
            # sometimes there are multiple sinks named after the app, so not returning early on purpose
            if sink.name == app_name:
                vol = pulse.volume_get_all_chans(sink)
                if increase:
                    new_vol = min(1, vol + VOLUME_INCREMENT)
                else:
                    new_vol = max(0, vol - VOLUME_INCREMENT)
                pulse.volume_set_all_chans(sink, new_vol)



# Generates a custom tile with run-time generated text and custom image via the
# PIL module.
def render_key_image(deck, label, background='black', image=None):
    # Resize the source image asset to best-fit the dimensions of a single key,
    # leaving a margin at the bottom so that we can draw the key title
    # afterwards.
    # image = PILHelper.create_image(deck, 'blue')
    # return PILHelper.to_native_format(deck, image)
    if image:
        icon = Image.open(image['file'])
        raw_image = PILHelper.create_scaled_image(deck, icon, margins=[0, 0, 30, 0], background=background)
    else:
        raw_image = PILHelper.create_image(deck, background)

    # Load a custom TrueType font and use it to overlay the key index, draw key
    # label onto the image a few pixels from the bottom of the key.
    if label['text']['text']:
        draw = ImageDraw.Draw(raw_image)
        font = ImageFont.truetype(**label['font'])
        draw.text(**label['text'], font=font)

    return PILHelper.to_native_format(deck, raw_image)

# Creates a new key image based on the key index, style and current key state
# and updates the image on the StreamDeck.
def update_key_image(deck, key, state):
    key_info = get_key_style(key, state)
    # Generate the custom key with the requested image and label.
    #render_key_image(deck, label, background='black', image=None):
    image = render_key_image(deck, key_info['label'], key_info['background'], key_info['image'])

    # Use a scoped-with on the deck to ensure we're the only thread using it
    # right now.
    with deck:
        # Update requested key with the generated image.
        deck.set_key_image(key.value, image)


def main():
    no_streamdeck_counter = 0
    while True:
        streamdecks = DeviceManager().enumerate()
        print(f'Found {len(streamdecks)} Stream Deck(s)', file=sys.stderr)
        if no_streamdeck_counter > 10:
            raise Exception('No Streamdecks found after waiting')
        if not streamdecks:
            time.sleep(0.5)
            no_streamdeck_counter += 1
            continue

        no_streamdeck_counter = 0
        for deck in streamdecks:
            try:
                deck.open()
                deck.reset()

                print(f'Opened {deck.deck_type()} device', file=sys.stderr)

                deck.set_brightness(35)

                # Set fire key initial events and set initial image
                for key in range(deck.key_count()):
                    try:
                        key = Keys(key)
                    except ValueError:
                        continue
                    update_key_image(deck, key, False)

                # Register callback function for when a key state changes.
                deck.set_key_callback(key_change_callback)

                # Wait until all application threads have terminated (for this example,
                # this is when all deck handles are closed).
                for t in threading.enumerate():
                    try:
                        t.join()
                    except RuntimeError:
                        pass
            except TransportError:
                pass

            if deck and deck.is_open():
                deck.reset()
            return 1

if __name__ == '__main__':
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        sys.exit(130)
