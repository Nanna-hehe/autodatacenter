import requests
from behave import given, then

# This is the base URL of the API you are testing
BASE_URL = "https://jsonplaceholder.typicode.com"

@given(u'I send a GET request to "{endpoint}"')
def step_impl(context, endpoint):
    url = f"{BASE_URL}{endpoint}"
    context.response = requests.get(url)

@then(u'the response status code should be {status_code:d}')
def step_impl(context, status_code):
    assert context.response.status_code == status_code, f"Expected {status_code}, but got {context.response.status_code}"

@then(u'the response should contain a list of posts')
def step_impl(context):
    response_json = context.response.json()
    assert isinstance(response_json, list), "Expected a list, but got a different type"

@then(u'the response should contain this post details')
def step_impl(context):
    response_json = context.response.json()

    # Convert the table data from the feature file into a dictionary
    expected_post = {row['userId']: row['id'] for row in context.table}

    # Check if the post details are in the response
    for row in context.table:
        key = row['userId']
        value = row['id']
        assert str(response_json.get(key)) == str(value), f"Expected {key}: {value}, but got {response_json.get(key)}"
