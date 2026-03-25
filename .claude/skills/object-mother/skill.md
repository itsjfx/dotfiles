---
name: object-mother
description: A test data pattern for Kotlin/Java that uses an Object Mother class with an inner Builder to produce readable, flexible, and consistent test fixtures. Use when writing or refactoring tests that need domain objects.
allowed-tools:
  - open_files
  - expand_code_chunks
  - grep
  - find_and_replace_code
  - create_file
---

# Object Mother Pattern for Tests in Kotlin/Java

When creating test data, use the **Object Mother** pattern with an inner **Builder** class. This keeps test setup readable, flexible, and consistent across the codebase.

## Structure

```kotlin
class ThingMother private constructor() {

    companion object {
        // Default constants for common values
        private const val DEFAULT_NAME = "test"
        private const val DEFAULT_ID = 1

        // Factory methods that return pre-configured builders for common scenarios.
        // Name them starting with "a" or "an" to read naturally.
        fun aThing(): ThingBuilder = ThingBuilder()
        fun anInvalidThing(): ThingBuilder = ThingBuilder().withName("")
        fun aDeletedThing(): ThingBuilder = ThingBuilder().withDeleted(true)
    }

    class ThingBuilder {
        // Fields with sensible defaults — a plain build() should produce a valid object
        private var id: Int = DEFAULT_ID
        private var name: String = DEFAULT_NAME

        // with* methods return `apply { ... }` for chaining
        fun withId(id: Int) = apply { this.id = id }
        fun withName(name: String) = apply { this.name = name }

        fun build(): Thing = Thing(id, name)
    }
}
```

## Rules

1. **Private constructor** on the Mother class — it's a namespace, not instantiated.
2. **Companion factory methods** return builders, not built objects. This lets tests customise only what they care about.
3. **Sensible defaults** — calling `aThing().build()` with no `with*` calls should produce a valid, usable object.
4. **Factory methods for common scenarios** — e.g. `aDeleteRecord()`, `anAuthenticatedContext()`. Each sets the builder fields that define that scenario, but tests can still override individual fields via `with*`.
5. **`with*` methods** for every field the builder holds. Each returns `apply { ... }` for fluent chaining.
6. **`build()` returns the final object**. All construction logic lives here.
7. **No mocks in Mothers** — Mothers produce real objects. If the object under construction requires complex sub-objects, create a separate Mother for those and compose them.
8. **Name the factory methods to read naturally** in test code: `SourceRecordMother.aCreateRecord().withId(5).build()`.

## Usage in Tests

```kotlin
// Minimal — uses all defaults
val thing = ThingMother.aThing().build()

// Override only what this specific test cares about
val thing = ThingMother.aThing().withName("custom").build()

// Use a scenario factory for a common variant
val deleted = ThingMother.aDeletedThing().withId(99).build()
```

## When to Use

- When writing new tests that need domain objects or DTOs as test data
- When refactoring existing tests that use inline constructors or repetitive setup
- When a test class has multiple tests that each construct slightly different versions of the same object
- When you see test code that is hard to read because of long constructor calls with many parameters

## Tips

- Place Mother classes in the same test package as the class they produce fixtures for
- Name the file `<Type>Mother.kt` or `<Type>Mother.java` (e.g. `MigrationPlanMother.kt`)
- If a Mother's builder needs another complex object, use that object's Mother inside `build()` — e.g. `AddressMother.anAddress().build()` inside `PersonMother.PersonBuilder.build()`
- Keep default values realistic but obviously fake (e.g. `"test-name"`, `"test@example.com"`, `12345`)
- Prefer `const val` for primitive defaults and top-level `val` for object defaults in the companion
- In Java, use a static inner class for the Builder and static factory methods on the Mother class instead of `companion object`
