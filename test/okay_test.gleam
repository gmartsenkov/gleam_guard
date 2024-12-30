import gleam/option
import gleeunit
import gleeunit/should
import okay.{ValidationError}

pub fn main() {
  gleeunit.main()
}

pub type TestEntities {
  User(id: Int, name: String, age: Int)
}

pub fn run_test() {
  let user = User(id: 1, name: "John", age: 20)

  okay.new()
  |> okay.field("age", okay.is_gt(user.age, 18))
  |> okay.field("name", okay.is_longer(user.name, 1))
  |> okay.run()
  |> should.be_ok

  let assert Error(validator) =
    okay.new()
    |> okay.field("age", okay.is_gt(user.age, 30))
    |> okay.field("name", okay.is_longer(user.name, 5))
    |> okay.run()

  let assert [first, second] = validator.errors
  should.equal(first, ValidationError("age", okay.IsGreater(20, 30)))
  should.equal(second, ValidationError("name", okay.IsLonger("John", 4, 5)))
}

pub fn is_gt_test() {
  should.be_ok(okay.is_gt(2, 1))
  should.be_error(okay.is_gt(1, 1))
  should.be_error(okay.is_gt(0, 1))

  let assert Error(err) = okay.is_gt(0, 1)
  should.equal(err, okay.IsGreater(0, 1))
}

pub fn is_gte_test() {
  should.be_ok(okay.is_gte(2, 1))
  should.be_ok(okay.is_gte(1, 1))
  should.be_error(okay.is_gte(0, 1))

  let assert Error(err) = okay.is_gte(0, 1)
  should.equal(err, okay.IsGreaterOrEqual(0, 1))
}

pub fn is_lt_test() {
  should.be_ok(okay.is_lt(1, 2))
  should.be_error(okay.is_lt(1, 1))
  should.be_error(okay.is_lt(2, 1))

  let assert Error(err) = okay.is_lt(2, 1)
  should.equal(err, okay.IsLesser(2, 1))
}

pub fn is_lte_test() {
  should.be_ok(okay.is_lte(1, 2))
  should.be_ok(okay.is_lte(1, 1))
  should.be_error(okay.is_lte(2, 1))

  let assert Error(err) = okay.is_lte(2, 1)
  should.equal(err, okay.IsLesserOrEqual(2, 1))
}

pub fn is_longer_test() {
  should.be_ok(okay.is_longer("bob", 1))
  should.be_error(okay.is_longer("bob", 3))
  should.be_error(okay.is_longer("bob", 4))

  let assert Error(err) = okay.is_longer("bob", 4)
  should.equal(err, okay.IsLonger(value: "bob", actual: 3, expected: 4))
}

pub fn is_equal_test() {
  should.be_ok(okay.is_equal("bob", "bob"))
  should.be_ok(okay.is_equal(1, 1))
  should.be_ok(okay.is_equal(2.2, 2.2))
  should.be_ok(okay.is_equal(True, True))
  should.be_error(okay.is_equal("a", "b"))
  should.be_error(okay.is_equal(1, 2))
  should.be_error(okay.is_equal(1.1, 1.2))
  should.be_error(okay.is_equal(True, False))

  let assert Error(err) = okay.is_equal(True, False)
  should.equal(err, okay.IsEqual("True", "False"))
}

pub fn is_included_in_test() {
  should.be_ok(okay.is_included_in("john", ["john", "bob"]))
  should.be_ok(okay.is_included_in(1, [1, 2]))
  should.be_error(okay.is_included_in("mark", ["john"]))
  should.be_error(okay.is_included_in(0, [1, 2]))

  let assert Error(err) = okay.is_included_in(1, [2, 3, 4])
  should.equal(err, okay.IsIncludedIn("1", "[2, 3, 4]"))
}

pub fn is_true_test() {
  should.be_ok(okay.is_true(True))
  should.be_error(okay.is_true(False))

  let assert Error(err) = okay.is_true(False)
  should.equal(err, okay.IsBool(value: False, expected: True))
}

pub fn is_false_test() {
  should.be_ok(okay.is_false(False))
  should.be_error(okay.is_false(True))

  let assert Error(err) = okay.is_false(True)
  should.equal(err, okay.IsBool(value: True, expected: False))
}

pub fn is_some_test() {
  should.be_ok(okay.is_some(option.Some(1)))
  should.be_error(okay.is_some(option.None))

  let assert Error(err) = okay.is_some(option.None)
  should.equal(err, okay.IsSome)
}

pub fn is_none_test() {
  should.be_ok(okay.is_none(option.None))
  should.be_error(okay.is_none(option.Some(1)))

  let assert Error(err) = okay.is_none(option.Some(1))
  should.equal(err, okay.IsNone("1"))
}
