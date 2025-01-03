# okay

[![Package Version](https://img.shields.io/hexpm/v/okay)](https://hex.pm/packages/okay)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/okay/)

`Okay` is a simple validation library, it provides a convenient to API to run validation checks at runtime.

```sh
gleam add okay@1
```
```gleam
import okay

pub type User {
  User(id: Int, name: String, age: Int)
}

pub fn main() {
  let user = User(id: 1, name: "John", age: 20)

  let assert Ok(_) = 
    okay.new()
    |> okay.field("age", okay.is_gt(user.age, 18))
    |> okay.field("name", okay.is_longer(user.name, 1))
    |> okay.run()

  let assert Error(validator) =
    okay.new()
    |> okay.field("age", okay.is_gt(user.age, 30))
    |> okay.field("name", okay.is_longer(user.name, 5))
    |> okay.run()

  let assert [first, second] = validator.failures
  io.debug(first) // ValidationError("age", IsGreaterFailure(value: 20, expected: 30))
  io.debug(second) // ValidationError("name", IsLongerFailure(value: "John", actual: 4, expected: 5))
}
```

It's also possible to define custom validation functions:

``` gleam
import okay

pub type User {
  User(name: String, is_admin: Bool)
}

fn is_admin(user: User) -> okay.ValidationResult {
  case user.is_admin {
    True -> Ok(Nil)
    False -> Error(okay.CustomFailure("Expected user to be admin"))
  }
}

pub fn main() {
  let user = User(name: "John", is_admin: 20)

  let assert Ok(_) = okay.new()
  |> okay.field("is_admin", is_admin(user))
  |> okay.run()

  let assert Error(validator) =
    okay.new()
    |> okay.field("is_admin", is_admin(user))
    |> okay.run()

  let assert [first] = validator.failures
  io.debug(first) // ValidationError("is_admin", CustomFailure("Expected user to be admin"))
}
```

Further documentation can be found at <https://hexdocs.pm/okay>.

## Development

```sh
gleam test  # Run the tests
```
