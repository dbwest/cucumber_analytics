Feature: Directories can be modeled.


  Acceptance criteria

  Directories containing feature files can be modeled:
    1. the directory's name
    2. the directory's full path
    3. all feature files contained
    4. all directories contained


  Background: Setup test directories
    Given a directory "feature_directory"
    And the following feature file "test_file_1.feature":
    """
    Feature: The test feature 1.

      Scenario: The first scenario's name.
        Given the first step
        When the second step
        Then the third step
    """
    And the following feature file "test_file_2.feature":
    """
    Feature: The test feature 2.

      Scenario: The first scenario's name.
        Given the first step
        When the second step
        Then the third step
    """
    And the following feature file "test_file_3.feature":
    """
    Feature: The test feature 3.

      Scenario: The first scenario's name.
        Given the first step
        When the second step
        Then the third step
    """
    And the following file "random.file":
    """
    Not a .feature file.
    """
    Given a directory "feature_directory/nested_directory"
    And the following feature file "test_file_4.feature":
    """
    Feature: The test feature 1.

      Scenario: The first scenario's name.
        Given the first step
        When the second step
        Then the third step
    """
    And the following feature file "test_file_5.feature":
    """
    Feature: The test feature 2.

      Scenario: The first scenario's name.
        Given the first step
        When the second step
        Then the third step
    """
    And the following file "another_random.file":
    """
    Not a .feature file.
    """
    When the directory "feature_directory" is read
    And the directory "feature_directory/nested_directory" is read

  Scenario: The directory's name is  modeled.
    Then directory "1" is found to have the following properties:
      | name | feature_directory |
    And directory "2" is found to have the following properties:
      | name | nested_directory |

  Scenario: The directory's full path is modeled.
    Then directory "1" is found to have the following properties:
      | path | path_to/feature_directory |
    And directory "2" is found to have the following properties:
      | path | path_to/feature_directory/nested_directory |

  Scenario: The directory's feature files are modeled.
    Then directory "1" is found to have the following properties:
      | feature_file_count | 3 |
    And directory "1" feature files are as follows:
      | test_file_1.feature |
      | test_file_2.feature |
      | test_file_3.feature |
    Then directory "2" is found to have the following properties:
      | feature_file_count | 2 |
    And directory "2" feature files are as follows:
      | test_file_4.feature |
      | test_file_5.feature |

  Scenario: The directory's directories are modeled.
    Then directory "1" is found to have the following properties:
      | directory_count | 1 |
    And directory "1" directories are as follows:
      | nested_directory |
    Then directory "2" is found to have the following properties:
      | directory_count | 0 |
    And directory "2" has no directories

  Scenario Outline: Directory models pass all other specifications
  Exact specifications detailing the API for directory models.
    Given that there are "<additional specifications>" detailing models
    When the corresponding unit tests are run
    Then all of those specifications are met
  Examples:
    | additional specifications |
    | directory_spec.rb         |
