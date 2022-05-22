*** Variables ***
${count}
${test_data}
${i}


**** Keywords ***
Start
    Open Browser    ${URL}   ${BROWSER}
    ${LOCATORS}         Read Json    ../Scripts/Resource/PageObjects/pizza_shop_locators.json 
    ${DATA}         Read Json    ../Scripts/Lib/TestData/pizza_shop_data.json 
    ${SCREEN_TEXTS}  Read Json    ../Scripts/Lib/TestData/pizza_shop_texts.json 
    Set Global Variable    ${DATA}
    Set Global Variable    ${LOCATORS}
    Set Global Variable    ${SCREEN_TEXTS}
    
    
    ${TIMEOUT}=    Set Selenium Timeout    10
    
Read Json
    [Documentation]    The function, with its' own keyword reads the json files.
    
    [Arguments]       ${file_path}
    ${JSONContent}    Get File        ${file_path}
    ${page}=          Evaluate        json.loads("""${JSONContent}""")    json
    [Return]          ${page}

Get ingredients
    [Arguments]    ${ingredient_list_from_command line}
    @{ingredients}=    Split String    ${ingredient_list_from_command line}    ,
    [Return]    @{ingredients} 

Iterate in ingredients
    [Arguments]    ${operation}   ${selected_ingredient}    ${new_ingredients}=""
    
    #Delete or Edit
    #iterate via the ingredients
    # Wait for 5 sec, because the backend may load slowly
    Sleep  5s
    ${ingredient_count}=    Get Element Count    ${LOCATORS["element"]}/*
    Log To Console    ${ingredient_count}

    Set Test Variable    ${element_found}    ${False}

    FOR    ${ingredient_index}    IN RANGE    1    ${ingredient_count}+1        
        IF    "${element_found}"=="${False}"
             ${element}=    Get Text    ${LOCATORS["element"]}/li[${ingredient_index}]
           
             # Buttons Delete and Edit are after the ingredient name, but use only the ingredient : apply Split operation
             ${ingredient}=    Split String    ${element}    Delete

             IF    "${ingredient}[0]"=="${selected_ingredient}"                  
                IF    "${operation}"=="Delete"                    
                    Click Button        ${LOCATORS["element"]}/li[${ingredient_index}]/button[1]                    
                END
                IF    "${operation}"=="Edit"
                        Click Button        ${LOCATORS["element"]}/li[${ingredient_index}]/button[2]
                        Add Ingredients
                END
                Set Test Variable    ${element_found}    ${True}
            END
        END
    END

    Wait Until Element Is Enabled    ${LOCATORS["locator_for_submit_recipe_button"]}
    Click Element    ${LOCATORS["locator_for_submit_recipe_button"]}



Add Ingredients
    
    ${ingredients}=    Get ingredients    ${LIST_OF_INGREDIENTS}

    FOR    ${ingredient}     IN      @{ingredients}
       
        #Add ingredient     
        #press Edit box with text Enter recipe ingredient  
        Wait Until Element Is Visible    ${LOCATORS["locator_ingredient"]}
        Click Element    ${LOCATORS["locator_ingredient"]}

        # add the ingredient from the list (@{ingredients})
        Input Text    name:ingredient    ${ingredient} 
         
        #Save ingredient
        Wait Until Element Is Enabled    ${LOCATORS["locator_for_add_ingredient_button"]}
        Click Element    ${LOCATORS["locator_for_add_ingredient_button"]}
    END

    # Submit the Recipe    
    Wait Until Element Is Enabled    ${LOCATORS["locator_for_submit_recipe_button"]}
    Click Element    ${LOCATORS["locator_for_submit_recipe_button"]}
    

Add Food
    # Recipe name
    # When using the a web element, at first wait until it is visible. Otherwise the test fails, as the web element cannot be handled.
    Wait Until Element Is Visible    ${LOCATORS["locator_for_recipe_name"]}
    
    # Click on the web element (Edit box), when it is visible	
    Click Element    ${LOCATORS["locator_for_recipe_name"]}

    # Write to the Edit box. One can do it, as it is visible, and it is already clicked.
    Input Text    name:name    ${TEST_FOOD_NAME}

Process input data    
        
    Wait Until Page Contains element    //*[@id="list-recipes"]/ul/li[1]/button[1]
     
    #counting the number of delete buttons is equal of the number of recipes on the screen
    ${count}=    Get Element Count    ${LOCATORS["delete_button_locator_start"]}/*

    ${locator_part}    Set Variable    ${EMPTY}
    ${test_data}    Set Variable    ${EMPTY}

    ${i}    Set Variable    0

    IF    "${TEST_FOOD_INDEX}"=="1"
        # index is not used at the command line, name is used instead
        # problem occurs, when index = 1 comes from the command line.
        # this is an ugly solution, will be corrected
        ${i}    Set Variable    1
        ${test_data}=    Set Variable    ${TEST_FOOD_NAME}     
    ELSE         
        # use the command line index
        ${test_data}=    Set Variable    ${TEST_FOOD_INDEX}
    END

    Set Global Variable    ${count}
    Set Global Variable    ${test_data}
    Set Global Variable    ${i}

Delete Last Element
    Wait Until Page Contains element    //*[@id="list-recipes"]/ul/li[1]/button[1]  

    ${count}=    Get Element Count    ${LOCATORS["delete_button_locator_start"]}/*
  
    # The newest element in the list-recipes list is at the end of the list, this is the one that will be deleted.  
    # Click on character X on the block of the recipe to delete  
    # Use the newly created variable ${count} in the xpath description of the web element
    Wait Until Element Is Visible    xpath=${LOCATORS["delete_button_locator_start"]}/li[${count}]/button[1]
    Click Element    xpath=${LOCATORS["delete_button_locator_start"]}/li[${count}]/button[1]

    
Find Pizza and Execute Instruction
    [Arguments]    ${delete_last}=""

    IF    ${delete_last}=="DeleteLastFood"
        Delete Last Element
    ELSE
        FOR    ${index}    IN RANGE    1    ${count}+1
        
            ${locator}=    Catenate    //*[@id="list-recipes"]/ul/li[${index}]/span
            ${text}=    Get Text    ${locator}

            ${text}=    Split String    ${text}    .
            ${text}=    Set Variable    ${text}[${i}]

          #check the pizza name or the index
            IF    "${text.strip()}"=="${test_data}"

                #check, whether add, delete, or edit ingredient
                Click Element    xpath=${LOCATORS["delete_button_locator_start"]}/li[${index}]/button[2]
                
	    
                # Delete and Edit are handled similarly, as new new recipe is added
                Run keyword IF    "${OPERATION}"=="Delete" or "${OPERATION}"=="Edit"    Iterate in ingredients    ${OPERATION}        ${TEST_INGREDIENT_NAME}    ${LIST_OF_INGREDIENTS}
      	        Run keyword IF    "${OPERATION}"=="Add"    Add Ingredients

                Run keyword IF    "${OPERATION}"=="DeletePizza"    Click Element    xpath=${LOCATORS["delete_button_locator_start"]}/li[${index}]/button[1]           
            
        END
    END
   END 

Is Text Displayed 
    [Arguments]    ${text_to_check}    
    Wait Until Page Contains     ${text_to_check}