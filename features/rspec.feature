@redo_bundle
Feature: Rspec
  Kender is able to run specs using the rspec tool.

  Background:
    Given a file named "Gemfile" with:
      """
      source 'https://rubygems.org'
      gem 'rspec', '~> 2.14'
      gem 'kender', path: '../../' # needed to use the latest code
      gem 'dice_bag', '~> 1.0'
      """
    And I run `bundle install --path vendor/`

  Scenario: The project has no specs but Rspec is executed
    When I run `bundle exec rake ci`
    Then it should pass with:
    """
    0 examples, 0 failures
    """

  Scenario: The project has some passing specs to run
    Given a file named "spec/testing_spec.rb" with:
      """
      describe "My software" do
        it "works wonderfully" do
          true
        end
      end
      """
    When I run `bundle exec rake ci`
    Then it should pass with:
    """
    1 example, 0 failures
    """
  
  Scenario: A project with failing specs should fail when running the ci:run task
    Given a file named "spec/testing_spec.rb" with:
      """
      describe "My software" do
        it "fails miserably" do
          expect(false).to be_true
        end
      end
      """
    When I run `bundle exec rake ci:run`
    Then the exit status should not be 0

  Scenario: The project has some non passing specs to run
    Given a file named "spec/testing_spec.rb" with:
      """
      describe "My software" do
        it "fails miserably" do
          expect(false).to be_true
        end
      end
      """
    When I run `bundle exec rake ci`
    Then the exit status should not be 0
