# This example Robot Framework test file stores a pizza recipes with ingredients

# The play wesite is not mine, I just found it

# Website location : https://timardex.github.io/react-recipe/

# The test contains the following test cases : 1. New Recipe creation
#				               2. Testing, whether adding new Recipe was successful
#				               3. Deleting existing recipes     : - last recipe
#                                                                                 - recipe defined with id
#                                                                                 - recipe defined with name  
#                                              4. Modifying existing recipes : - add new ingredient to recipe (idenfified with name or id)
#                                                                              - modifying ingredient in a recipe (idenfified with name or id)
#                                                                              - delete ingredient (idenfified with name or id)
                  

*** Settings ***
Library    Selenium2Library
Library    OperatingSystem  
Library           Collections
Library           requests
Library           String
Suite Setup     Start
Suite Teardown  Close All Browsers
Resource    ../TestSteps/testSteps.robot
 
*** Variables ***
${URL}                  https://timardex.github.io/react-recipe/
${BROWSER}              Chrome
${TEST_FOOD_NAME}       DelicousScrambledEggs
${TEST_FOOD_INDEX}      1
${LIST_OF_INGREDIENTS}  cheese,salami
${OPERATION}            DeletePizza
 
*** Test Cases ***
Add Food

    Add Food
    Add Ingredients

    Is Text Displayed     ${SCREEN_TEXTS["created"]}
  
    Sleep    2s


Test Added Food
    ${food_name_locator}=    Catenate    ${LOCATORS["locator_for_test_food_name_start"]}${TEST_FOOD_NAME}${LOCATORS["locator_for_test_food_name_end"]}
    Wait Until Page Contains element  ${food_name_locator}  timeout=5   

Delete Last Food

    Find Pizza and Execute Instruction    "DeleteLastFood"

    Is Text Displayed     ${SCREEN_TEXTS["deleted"]}

    Sleep    5s

    
Delete Specific Food

    Process input data    
    Find Pizza and Execute Instruction   
    Is Text Displayed     ${SCREEN_TEXTS["deleted"]}
    
    Sleep    5s


Modify Selected Food

    Process input data    
    Find Pizza and Execute Instruction

    Is Text Displayed    ${SCREEN_TEXTS["updated"]}

    Sleep    5s
    
                                                