This Robot Framework project is an example of Test Automation against a website that I found on the internet : 

https://timardex.github.io/react-recipe/

The website on the internet is a simple example for storing Recipes of different foods.

The Robot project can do the same as the website. The project 

The following routines are in the Robot project : 

- Add Element

  Parameters : 
      ADD_TEST_FOOD_NAME

- Test Add Element

  Description : Tests, whether certain Food is in the list of foods

  Parameters : ADD_TEST_FOOD_NAME

- Delete Last Element

  Parameters : -

Delete Selected Element : 

  Parameters : DELETE_TEST_FOOD_INDEX
               or
               DELETE_TEST_FOOD_NAME

 

Some example of running the script : 

Adding a new food :

  robot -t "Add Element" -v TEST_FOOD_NAME:"Pizza Tonno" -v LIST_OF_INGREDIENTS:"pizza,tonno" playground_test.robot

Test the existence of a specific food (Assume, that Pizza funghi is in the list) : 
  
  robot -t "Test Add Element" -v TEST_FOOD_NAME:"Pizza Tonno" playground_test.robot

Delete last food :

  robot -t "Delete Last Element" playground_test.robot 

Delete Specific Element :

    robot -t "Delete Specific Element" -v TEST_FOOD_NAME:"Pizza funghi" playground_test.robot

    robot -t "Delete Specific Element" -v TEST_FOOD_INDEX:"290" playground_test.robot

Add Ingredient to Existing Recipe (Be sure, that recipe exists)

    robot -t "Modify Selected Element" -v TEST_FOOD_INDEX:"302" -v OPERATION:"Add" -v LIST_OF_INGREDIENTS:"wine,beer" playground_test.robot

Delete ingredient from existing recipe with index

    robot -t "Modify Selected Element" -v TEST_FOOD_INDEX:"302" -v OPERATION:"Delete" -v TEST_INGREDIENT_NAME:"wine" playground_test.robot

Delete ingredient from existing recipe with name

    robot -t "Modify Selected Element" -v TEST_FOOD_NAME:"Kaja" -v OPERATION:"Delete" -v TEST_INGREDIENT_NAME:"kenyer" playground_test.robot

Modify existing ingredient with name

    robot -t "Modify Selected Element" -v TEST_FOOD_NAME:"Kaja" -v OPERATION:"Edit" -v TEST_INGREDIENT_NAME:"korte" -v LIST_OF_INGREDIENTS:"kokuszdio"     playground_test.robot

Modify existing ingredient with index

    robot -t "Modify Selected Element" -v TEST_FOOD_INDEX:"302" -v OPERATION:"Edit" -v TEST_INGREDIENT_NAME:"alma" -v LIST_OF_INGREDIENTS:"aranyalma"     playground_test.robot


