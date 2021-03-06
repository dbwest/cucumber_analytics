### Version 1.6.0 / 2016-10-19

* Version limits on all of this gem's dependencies are now declared by the gem.


### Version 1.5.2 / 2016-01-21

* Bug fix: Fixed an error caused by comparing elements with step objects to
  anything that did not have step objects.


### Version 1.5.1 / 2014-05-26

* Version ranges have been removed for the gherkin gem. Since this gem can work 
  with any version of gherkin, ensuring that the avaialble version of the 
  gherkin gem actually works on the user's version of Ruby is left as a concern 
  best handled externally.


### Version 1.5.0 / 2014-02-04

* Version ranges have been added for gem dependencies.
* \#to_s has been overridden for elements so that it returns text suitable for
  use as gherkin source code.


### Version 1.4.2 / 2014-01-26

* Bug fix: Example#add_row no longer assumes that the key/value pairs in a
  Hash are ordered. This was causing values in the added row to be assigned
  to the incorrect parameter when using versions of Ruby before 1.9.x.


### Version 1.4.1 / 2013-12-25

* Bug fix: Trailing empty lines are no longer left out of the contents of doc
  string models.


### Version 1.4.0 / 2013-11-05

* Step table rows are now modeled. Non-object table rows have been retained in
  order to remain backwards compatible.


### Version 1.3.0 / 2013-10-02

* Elements now have a convenience method for accessing their ancestor elements.


### Version 1.2.0 / 2013-09-01

* Bug fix: nil no longer shows up as a child element of a Feature if the Feature
  does not have a Background object.
* Elements now have access to their original parsed structure as returned by the
  gherkin gem.
* Tags are now modeled. Non-object tags are still the default in order to remain
  backwards compatible.


### Version 1.1.1 / 2013-08-03

* Version bumped due to publishing wrong code for version 1.1.0.


### Version 1.1.0 / 2013-08-01

* Outline example rows are now modeled.
* Some elements now keep track of which source code line number they started on.
* Step definition patterns that have been loaded in the World can now be cleared.


### Version 1.0.0 / 2013-06-30

* Bug fix: Step definitions are now detected whether or not parenthesis are
  used in the declararion.
* Now using the gherkin gem to parse feature files. This should eliminate most
  parsing related bugs.
* Empty outline example blocks can no longer be handeled (since the gherkin gem
  can, likewise, not handle them).
* Source code snippets can now be analyzed (rather than needing an entire feature
  file to parse).
* Logging has been removed from the gem due to its significant negative impact
  on performance.
* Many class and method names have changed.
* Significant API overhaul, including several new classes for modeling.


### Version 0.0.9 / 2013-02-25

* Bug fix: Fixed an un-anchored regular expression that was causing
  feature files to be parsed incorrectly.


### Version 0.0.8 / 2013-02-24

* Bug fix: Replaced some destructive method calls with non-destructive
  equivalents.
* Bug fix: Fixed some parsing bugs based around whitespace.
* Subdirectories within a directory are now modeled.
* Directory collection added.


### Version 0.0.7 / 2013-02-01

* Bug fix: Feature collection no longer returns nil values for feature files
  that do not contain features.
* Elements now know the element that contains them.
* Adjusted the default logging level so that logging does not occur by default.


### Version 0.0.6 / 2013-01-07

* Improved support for example blocks in outlines.
* Modeling of empty feature files is now possible.
* Modeling of inherited tags has been added.


### Version 0.0.5 / 2012-12-16

* Bug fix: a missing 'require' statement that was causing loading errors has
  been fixed.


### Version 0.0.4 / 2012-12-13

* Removed an unintentional gem dependency.
* Improved 1.8.7 compatibility.


### Version 0.0.3 / 2012-11-10

* 'But' has been added to the list of recognized step keywords (formerly Given,
  When,Then, And, and *).
* Bug fix: the number of test cases a feature is considered to contain now
  properly takes into account an outline's example rows.


### Version 0.0.2 / 2012-11-01

* Bug fix: descriptions are no longer cut short due to the presence of keywords.


### Version 0.0.1 / 2012-10-28

* Initial release
