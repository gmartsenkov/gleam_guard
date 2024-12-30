# okay

[![Package Version](https://img.shields.io/hexpm/v/okay)](https://hex.pm/packages/okay)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/okay/)

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

  let assert Ok(_) = okay.new()
  |> okay.field("age", okay.is_gt(user.age, 18))
  |> okay.field("name", okay.is_longer(user.name, 1))
  |> okay.run()

  let assert Error(validator) =
    okay.new()
    |> okay.field("age", okay.is_gt(user.age, 30))
    |> okay.field("name", okay.is_longer(user.name, 5))
    |> okay.run()

  let assert [first, second] = validator.errors
  io.debug(first) // ValidationError("age", IsGreater(value: 20, expected: 30))
  io.debug(second) // ValidationError("name", IsLonger(value: "John", actual: 4, expected: 5))
}
```

Further documentation can be found at <https://hexdocs.pm/okay>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
```
