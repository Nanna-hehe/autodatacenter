*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${BROWSER}    chrome
${URL}    https://jsonplaceholder.typicode.com/


*** Test Cases ***
Example Test Case
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Page Should Contain    {JSON} Placeholder
    Click Button    id=run-button
    Wait Until Element Is Visible    xpath=//p[@id='run-message' and contains(text(), "Congrats! You've made your first call to JSONPlaceholder. 😃 🎉")]
    Page Should Contain    delectus aut autem
    [Teardown]    Close Browser