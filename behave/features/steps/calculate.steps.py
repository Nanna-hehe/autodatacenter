from behave import given, then, when


@given("I have the number {initialValue}")
def given_number(context, initialValue: str):
    context.number1 = int(initialValue)


@when("I increase it by {value}")
def when_increase(context, value: str):
    context.result = context.number1 + int(value)


@when("I subtract {value} from it")
def when_subtract(context, value: str):
    context.result = context.number1 - int(value)


@then("the result should return {expected}")
def then_return(context, expected: str):
    assert context.result == int(expected)
