# This example Robot Framework test file stores a new Recipe with 1 Ingredient on a play website

# The play wesite is not mine, I just found it

# Website location : https://timardex.github.io/react-recipe/

# The test contains 3 sections : 1. New Recipe creation
#				 2. Testing, whether adding new Recipe was successful
#				 3. Deleting of new Recipe (it was added only for the test). 


*** Settings ***
Library    Selenium2Library
Library    OperatingSystem  
Library           Collections
Library           requests
Library           String
Suite Setup     Open Browser    ${URL}   ${BROWSER}
Suite Teardown  Close All Browsers
 
 
*** Variables ***
${URL}              https://timardex.github.io/react-recipe/
${BROWSER}          Chrome

${DELETE_BUTTON_LOCATOR_START}         //*[@id="list-recipes"]/ul
${LOCATOR_FOR_TEST_FOOD_NAME_START}          //*[text()='
${LOCATOR_FOR_TEST_FOOD_NAME_END}            ']
${LOCATOR_FOR_RECIPE_NAME}             //*[@id="create-recipe"]/div[1]/div[1]/input
${LOCATOR_INGREDIENT}                  //*[@id="create-recipe"]/div[1]/div[2]/input
${TEST_FOOD_NAME}                      Test Scrambled Eggs
${TEST_FOOD_INDEX}                      1
${TEST_FOOD_NAME}                      Test Scrambled Eggs
${TEST_INGREDIENT_NAME}                Egg
${LOCATOR_FOR_ADD_INGREDIENT_BUTTON}   xpath=//*[@id="create-recipe"]/div[1]/div[2]/button
${LOCATOR_FOR_SUBMIT_RECIPE_BUTTON}    xpath=//*[@id="create-recipe"]/button
${LIST_OF_INGREDIENTS}                 meat,onion,cheese


**** Keywords ***
Get ingredients
    [Arguments]    ${ingredient_list_from_command line}
    @{ingredients}=    Split String    ${ingredient_list_from_command line}    ,
    [Return]    @{ingredients} 

Iterate in ingredients
    [Arguments]    ${operation}   ${selected_ingredient}    ${new_ingredients}
    Log to console    Inside delete or Edit
    #Delete or Edit
    #iterate via the ingredients
    ${ingredient_count}=    Get Element Count    //*[@id="create-recipe"]/div[2]/ul/*
    Log to console    AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaa
    Log to console    ${ingredient_count}
    Set Test Variable    ${element_found}    ${False}

    ${length}=    Get Length    "${NEW_TEST_FOOD_NAME}"
    IF    ${length}>0
        Log to console    New name
        Add Name    ${NEW_TEST_FOOD_NAME}
        Sleep    2s
    END
    FOR    ${ingredient_index}    IN RANGE    1    ${ingredient_count}+1
        IF    "${element_found}"=="${False}"
            ${element}=    Get Text    //*[@id="create-recipe"]/div[2]/ul/li[${ingredient_index}]
            Log to console    ${element}
            ${ingredient}=    Split String    ${element}    Delete
            Log to console    ${ingredient}
            Log to console    ${ingredient}[0] 
            Log to console    ${selected_ingredient}
            IF    "${ingredient}[0]"=="${selected_ingredient}"  
                Log to console    Element is recognized
                IF    "${operation}"=="Delete"
                    Log to console    I will delete now
                    Click Button        //*[@id="create-recipe"]/div[2]/ul/li[${ingredient_index}]/button[1]
                END
                IF    "${operation}"=="Edit"
                    Log to console    I will edit now
                    
                    ${length}=    Get Length    "${LIST_OF_INGREDIENTS}"
                    IF    ${length}>0
                        Click Button        //*[@id="create-recipe"]/div[2]/ul/li[${ingredient_index}]/button[2]
                        Add Ingredients
                    ELSE
			# Submit the Recipe    
  		        Wait Until Element Is Enabled    ${LOCATOR_FOR_SUBMIT_RECIPE_BUTTON}
   		        Click Element    ${LOCATOR_FOR_SUBMIT_RECIPE_BUTTON}
                    END
                END
                Set Test Variable    ${element_found}    ${True}
            END
        END
    END

    Wait Until Element Is Enabled    ${LOCATOR_FOR_SUBMIT_RECIPE_BUTTON}
    Click Element    ${LOCATOR_FOR_SUBMIT_RECIPE_BUTTON}

    Sleep    2s



Add Ingredients
    
    ${ingredients}=    Get ingredients    ${LIST_OF_INGREDIENTS}

    FOR    ${ingredient}     IN      @{ingredients}
       
        #Add ingredient       
        Wait Until Element Is Visible    ${LOCATOR_INGREDIENT}
        Click Element    ${LOCATOR_INGREDIENT}
        Input Text    name:ingredient    ${ingredient} 
         
        #Save ingredient
        Wait Until Element Is Enabled    ${LOCATOR_FOR_ADD_INGREDIENT_BUTTON}
        Click Element    ${LOCATOR_FOR_ADD_INGREDIENT_BUTTON}
    END

    # Submit the Recipe    
    Wait Until Element Is Enabled    ${LOCATOR_FOR_SUBMIT_RECIPE_BUTTON}
    Click Element    ${LOCATOR_FOR_SUBMIT_RECIPE_BUTTON}

    Sleep    5s

Add Name
    [Arguments]    ${food_name}
    # Recipe name
    # When using the a web element, at first wait until it is visible. Otherwise the test fails, as the web element cannot be handled.
    Wait Until Element Is Visible    ${LOCATOR_FOR_RECIPE_NAME}
    
    # Click on the web element (Edit box), when it is visible	
    Click Element    ${LOCATOR_FOR_RECIPE_NAME}

    # Write to the Edit box. One can do it, as it is visible, and it is already clicked.
    Input Text    name:name    ${food_name}

 
*** Test Cases ***
Add Element

    # Ingredient name
    # Same as above...
#    Wait Until Element Is Visible    ${LOCATOR_INGREDIENT}
#    Click Element    ${LOCATOR_INGREDIENT}
#    Input Text    name:ingredient    ${TEST_INGREDIENT_NAME}
    
    # Add ingredient
#    ${ingredients}=    Get ingredients    ${LIST_OF_INGREDIENTS}
#    Log to console    Ingredients
#    Log to console    ${ingredients}
#    Wait Until Element Is Enabled    ${LOCATOR_FOR_ADD_INGREDIENT_BUTTON}
#    Click Element    ${LOCATOR_FOR_ADD_INGREDIENT_BUTTON}			   

    Add Name    ${TEST_FOOD_NAME}
    Add Ingredients

    

  

    Sleep    2s


Test Add Element
    ${food_name_locator}=    Catenate    ${LOCATOR_FOR_TEST_FOOD_NAME_START}${TEST_FOOD_NAME}${LOCATOR_FOR_TEST_FOOD_NAME_END}
    Wait Until Page Contains element  ${food_name_locator}  timeout=5   


Delete Last Element
 
    Wait Until Page Contains element    //*[@id="list-recipes"]/ul/li[1]/button[1]  

    ${count}=    Get Element Count    ${DELETE_BUTTON_LOCATOR_START}/*
    Log to console    *************************************
    Log to console    ${count}  

    #Delete the * character from end of    ${DELETE_BUTTON_LOCATOR_START}
  
    # The newest element in the list-recipes list is at the end of the list, this is the one that will be deleted.  
    # Click on character X on the block of the recipe to delete  
    # Use the newly created variable ${count} in the xpath description of the web element
    Sleep    3
#    ${food_index_to_delete}=    ${count}+1
    Click Element    xpath=${DELETE_BUTTON_LOCATOR_START}/li[${count}]/button[1]
    Sleep    3
    
Delete Specific Element

    Wait Until Page Contains element    //*[@id="list-recipes"]/ul/li[1]/button[1]

    ${count}=    Get Element Count    ${DELETE_BUTTON_LOCATOR_START}/*
    Log to console    ${count}

    ${locator_part}    Set Variable    ${EMPTY}
    ${test_data}    Set Variable    ${EMPTY}

    ${i}    Set Variable    0

    IF    "${TEST_FOOD_INDEX}"=="1"
  #      ${locator_part}    Set Variable    /u
        ${i}    Set Variable    1
        ${test_data}=    Set Variable    ${TEST_FOOD_NAME}
    ELSE 
        
 #       ${locator_part}    Set Variable    /u
        ${test_data}=    Set Variable    ${TEST_FOOD_INDEX}
    END

    

    FOR    ${index}    IN RANGE    1    ${count}+1
        ${locator}=    Catenate    //*[@id="list-recipes"]/ul/li[${index}]/span
        ${text}=    Get Text    ${locator}
        Log to console    ${text}
        ${text}=    Split String    ${text}    .
        Log to console    ${text}
        ${text}=    Set Variable    ${text}[${i}]
        Log to console    Listen
        Log to console    ${text}
        Log to console    ${test_data}
        IF    "${text.strip()}"=="${test_data}"
            Log to console    Element will be deleted
            Click Element    xpath=${DELETE_BUTTON_LOCATOR_START}/li[${index}]/button[1] 
        END
    END

    Sleep    2s

Modify Selected Element
    Sleep    5s
    Wait Until Page Contains element    //*[@id="list-recipes"]/ul/li[1]/button[1]

    ${count}=    Get Element Count    ${DELETE_BUTTON_LOCATOR_START}/*
    Log to console    ${count}

    ${locator_part}    Set Variable    ${EMPTY}
    ${test_data}    Set Variable    ${EMPTY}

    ${i}    Set Variable    0

    IF    "${TEST_FOOD_INDEX}"=="1"
  #      ${locator_part}    Set Variable    /u
        ${i}    Set Variable    1
        ${test_data}=    Set Variable    ${TEST_FOOD_NAME}
    ELSE 
        
 #       ${locator_part}    Set Variable    /u
        ${test_data}=    Set Variable    ${TEST_FOOD_INDEX}
    END

    

    FOR    ${index}    IN RANGE    1    ${count}+1
        ${locator}=    Catenate    //*[@id="list-recipes"]/ul/li[${index}]/span
        ${text}=    Get Text    ${locator}
        Log to console    ${text}
        ${text}=    Split String    ${text}    .
        Log to console    ${text}
        ${text}=    Set Variable    ${text}[${i}]
        Log to console    Listen
        Log to console    ${text}
        Log to console    ${test_data}
        IF    "${text.strip()}"=="${test_data}"
            Log to console    Element will be edited
            Log to console    ${OPERATION}
            #check, whether add, delete, or edit ingredient
            Click Element    xpath=${DELETE_BUTTON_LOCATOR_START}/li[${index}]/button[2]
            Sleep    5s
	    Log to console    ${DELETE_BUTTON_LOCATOR_START}/li[${index}]/button[2]
            Run keyword IF    "${OPERATION}"=="Delete" or "${OPERATION}"=="Edit"    Iterate in ingredients    ${OPERATION}    ${TEST_INGREDIENT_NAME}    ${LIST_OF_INGREDIENTS}
  	    Run keyword IF    "${OPERATION}"=="Add"    Add Ingredients
          
            
        END
    END
    
                                                