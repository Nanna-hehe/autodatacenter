const {
    Given,
    Then,
  } = require("@cucumber/cucumber");
  const axios = require("axios");
  const assert = require("assert");
  
  let response;
  
  Given(
    "I send a GET request to {string}",
    async function (url) {
      response = await axios.get(
        `https://jsonplaceholder.typicode.com${url}`,
      );
    },
  );
  
  Then(
    "the response status code should be {int}",
    function (statusCode) {
      assert.strictEqual(
        response.status,
        statusCode,
      );
    },
  );
  
  Then(
    "the response should contain a list of posts",
    function () {
      assert(Array.isArray(response.data));
    },
  );
  
  Then(
    "the response should contain this post details",
    function (dataTable) {
      const expectedData = dataTable.rowsHash();
  
      const post = response.data.find(
        (p) => p.id == expectedData.id,
      );
  
      const numberFields = ["userId", "id"];
  
      if (!post) {
        throw new Error(
          `Post with id ${expectedData.id} was not found in the response data.`,
        );
      }
  
      Object.keys(expectedData).forEach((key) => {
        assert.strictEqual(
          post[key],
          numberFields.includes(key)
            ? parseInt(expectedData[key])
            : expectedData[key],
        );
      });
    },
  );
  