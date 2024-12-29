import gleam/list
import gleam/string

pub type Error {
  IsGreater(value: Int, expected: Int)
  IsGreaterOrEqual(value: Int, expected: Int)
  IsLonger(value: String, actual: Int, expected: Int)
  IsLesser(value: Int, expected: Int)
  IsLesserOrEqual(value: Int, expected: Int)
  IsEqual(value: String, expected: String)
  IsIncludedIn(value: String, expected: String)
  IsBool(value: Bool, expected: Bool)
}

pub type ValidationError {
  ValidationError(field: String, error: Error)
}

pub type Guard {
  Guard(errors: List(ValidationError))
}

pub fn run(guard: Guard) -> Result(Nil, Guard) {
  case list.is_empty(guard.errors) {
    True -> Ok(Nil)
    False -> Error(guard)
  }
}

pub fn new() -> Guard {
  Guard(errors: [])
}

pub fn field(guard: Guard, field: String, result: Result(Nil, Error)) -> Guard {
  case result {
    Error(error) -> {
      let updated_errors =
        list.append(guard.errors, [ValidationError(field:, error:)])

      Guard(errors: updated_errors)
    }
    _ -> guard
  }
}

pub fn is_included_in(value: t, whitelist: List(t)) -> Result(Nil, Error) {
  case list.contains(whitelist, value) {
    True -> Ok(Nil)
    False ->
      Error(IsIncludedIn(string.inspect(value), string.inspect(whitelist)))
  }
}

pub fn is_longer(value: String, length: Int) -> Result(Nil, Error) {
  let value_length = string.length(value)
  case value_length > length {
    True -> Ok(Nil)
    False -> Error(IsLonger(value, value_length, length))
  }
}

pub fn is_equal(value: t, compare: t) -> Result(Nil, Error) {
  case value == compare {
    True -> Ok(Nil)
    False -> Error(IsEqual(string.inspect(value), string.inspect(compare)))
  }
}

pub fn is_gt(value: Int, compare: Int) -> Result(Nil, Error) {
  case value > compare {
    True -> Ok(Nil)
    False -> Error(IsGreater(value, compare))
  }
}

pub fn is_lt(value: Int, compare: Int) -> Result(Nil, Error) {
  case value < compare {
    True -> Ok(Nil)
    False -> Error(IsLesser(value, compare))
  }
}

pub fn is_lte(value: Int, compare: Int) -> Result(Nil, Error) {
  case value <= compare {
    True -> Ok(Nil)
    False -> Error(IsLesserOrEqual(value, compare))
  }
}

pub fn is_gte(value: Int, compare: Int) -> Result(Nil, Error) {
  case value >= compare {
    True -> Ok(Nil)
    False -> Error(IsGreaterOrEqual(value, compare))
  }
}

pub fn is_true(value: Bool) -> Result(Nil, Error) {
  case value == True {
    True -> Ok(Nil)
    False -> Error(IsBool(value, True))
  }
}

pub fn is_false(value: Bool) -> Result(Nil, Error) {
  case value == False {
    True -> Ok(Nil)
    False -> Error(IsBool(value, False))
  }
}
