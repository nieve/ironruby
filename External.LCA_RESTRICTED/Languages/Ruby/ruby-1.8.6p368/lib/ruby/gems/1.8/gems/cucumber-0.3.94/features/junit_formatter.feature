Feature: JUnit output formatter
  In order for developers to create test reports with ant
  Cucumber should be able to output JUnit xml files
  
  Background:
    Given I am in junit
    And the tmp directory is empty
  
  @mri186
  Scenario: one feature, one passing scenario, one failing scenario
    When I run cucumber --format junit --out tmp/ features/one_passing_one_failing.feature
    Then it should fail with
      """

      """
    And "examples/junit/tmp/TEST-one_passing_one_failing.xml" with junit duration "0.005" should contain
      """
      <?xml version="1.0" encoding="UTF-8"?>
      <testsuite errors="0" failures="1" name="One passing scenario, one failing scenario" tests="2" time="0.005">
      <testcase classname="One passing scenario, one failing scenario.Passing" name="Passing" time="0.005">
      </testcase>
      <testcase classname="One passing scenario, one failing scenario.Failing" name="Failing" time="0.005">
        <failure message="failed Failing" type="failed">
      Scenario: Failing

      Given a failing scenario

      Message:
       (RuntimeError)
      ./features/step_definitions/steps.rb:6:in `/a failing scenario/'
      features/one_passing_one_failing.feature:7:in `Given a failing scenario'  </failure>
      </testcase>
      </testsuite>

      """
  
  @mri186
  Scenario: pending step
    When I run cucumber --format junit --out tmp/ features/pending.feature
    Then it should pass with
      """
      
      """
    And "examples/junit/tmp/TEST-pending.xml" with junit duration "0.009" should contain
      """
      <?xml version="1.0" encoding="UTF-8"?>
      <testsuite errors="0" failures="1" name="Pending step" tests="1" time="0.009">
      <testcase classname="Pending step.Pending" name="Pending" time="0.009">
        <failure message="pending Pending" type="pending">
      Scenario: Pending

      TODO (Cucumber::Pending)
      ./features/step_definitions/steps.rb:10:in `/a pending step/'
      features/pending.feature:4:in `Given a pending step'  </failure>
      </testcase>
      </testsuite>
      
      """
    
  Scenario: run all features
    When I run cucumber --format junit --out tmp/ features
    Then it should fail with
      """
      
      """
    And "examples/junit/tmp/TEST-one_passing_one_failing.xml" should exist
    And "examples/junit/tmp/TEST-pending.xml" should exist
  
  Scenario: show correct error message if no --out is passed
    When I run cucumber --format junit features
	  Then STDERR should not match 
		  """
can't convert .* into String \(TypeError\)
		  """
    And STDERR should match
		  """
You \*must\* specify \-\-out DIR for the junit formatter
	    """