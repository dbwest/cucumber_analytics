require 'spec_helper'

SimpleCov.command_name('Step') unless RUBY_VERSION.to_s < '1.9.0'

describe 'Step, Unit' do

  clazz = CucumberAnalytics::Step

  it_should_behave_like 'a nested element', clazz
  it_should_behave_like 'a bare bones element', clazz
  it_should_behave_like 'a prepopulated element', clazz


  before(:each) do
    @step = clazz.new
  end

  it 'has arguments - #arguments' do
    @step.should respond_to(:arguments)
  end

  it 'can get and set its arguments - #arguments, #arguments=' do
    @step.arguments = :some_arguments
    @step.arguments.should == :some_arguments
    @step.arguments = :some_other_arguments
    @step.arguments.should == :some_other_arguments
  end

  it 'starts with no arguments' do
    @step.arguments.should == []
  end

  it 'has a base - #base' do
    @step.should respond_to(:base)
  end

  it 'can get and set its base - #base, #base=' do
    @step.base = :some_base
    @step.base.should == :some_base
    @step.base = :some_other_base
    @step.base.should == :some_other_base
  end

  it 'starts with no base' do
    @step.base.should == nil
  end

  it 'has a block - #block' do
    @step.should respond_to(:block)
  end

  it 'can get and set its block - #block, #block=' do
    @step.block = :some_block
    @step.block.should == :some_block
    @step.block = :some_other_block
    @step.block.should == :some_other_block
  end

  it 'starts with no block' do
    @step.block.should == nil
  end

  it 'has a keyword - #keyword' do
    @step.should respond_to(:keyword)
  end

  it 'can get and set its keyword - #keyword, #keyword=' do
    @step.keyword = :some_keyword
    @step.keyword.should == :some_keyword
    @step.keyword = :some_other_keyword
    @step.keyword.should == :some_other_keyword
  end

  it 'starts with no keyword' do
    @step.keyword.should == nil
  end

  it 'has a left delimiter - #left_delimiter' do
    @step.should respond_to(:left_delimiter)
  end

  it 'can get and set its left delimiter - #left_delimiter, #left_delimiter=' do
    @step.left_delimiter = :some_left_delimiter
    @step.left_delimiter.should == :some_left_delimiter
    @step.left_delimiter = :some_other_left_delimiter
    @step.left_delimiter.should == :some_other_left_delimiter
  end

  it 'starts with no left delimiter' do
    @step.left_delimiter.should == nil
  end

  it 'has a right delimiter - #right_delimiter' do
    @step.should respond_to(:right_delimiter)
  end

  it 'can get and set its right delimiter - #right_delimiter, #right_delimiter=' do
    @step.right_delimiter = :some_right_delimiter
    @step.right_delimiter.should == :some_right_delimiter
    @step.right_delimiter = :some_other_right_delimiter
    @step.right_delimiter.should == :some_other_right_delimiter
  end

  it 'starts with no right delimiter' do
    @step.right_delimiter.should == nil
  end

  it 'can determine its arguments based on a regular expression' do
    source = 'Given a test step with a parameter'
    step = CucumberAnalytics::Step.new(source)

    step.scan_arguments(/parameter/)
    step.arguments.should == ['parameter']
    step.scan_arguments(/t s/)
    step.arguments.should == ['t s']
  end

  it 'can determine its arguments based on delimiters' do
    source = 'Given a test step with -parameter 1- and -parameter 2-'

    step = CucumberAnalytics::Step.new(source)

    step.scan_arguments('-', '-')
    step.arguments.should == ['parameter 1', 'parameter 2']
    step.scan_arguments('!', '!')
    step.arguments.should == []
  end

  it 'can explicitly scan for arguments' do
    @step.should respond_to(:scan_arguments)
  end

  it 'can use different left and right delimiters when scanning' do
    source = 'Given a test step with !a parameter-'

    step = CucumberAnalytics::Step.new(source)

    step.scan_arguments('!', '-')
    step.arguments.should == ['a parameter']
  end

  it 'can set both of its delimiters at once - #delimiter=' do
    @step.delimiter = :new_delimiter
    @step.left_delimiter.should == :new_delimiter
    @step.right_delimiter.should == :new_delimiter
  end

  it 'can use delimiters of varying lengths' do
    source = 'Given a test step with -start-a parameter-end-'

    step = CucumberAnalytics::Step.new(source)

    step.scan_arguments('-start-', '-end-')
    step.arguments.should == ['a parameter']
  end

  it 'can handle delimiters with special regular expression characters' do
    source = 'Given a test step with \d+a parameter.?'

    step = CucumberAnalytics::Step.new(source)

    step.scan_arguments('\d+', '.?')
    step.arguments.should == ['a parameter']
  end

  it 'defaults to its set delimiters when scanning' do
    source = 'Given a test step with *parameter 1* and "parameter 2" and *parameter 3*'
    step = CucumberAnalytics::Step.new(source)

    step.left_delimiter = '"'
    step.right_delimiter = '"'
    step.scan_arguments

    step.arguments.should == ['parameter 2']
  end

  it 'can be parsed from stand alone text' do
    source = '* some step'

    expect { clazz.new(source) }.to_not raise_error
  end

  it 'can determine its equality with another Step' do
    source_1 = "Given a test step with *parameter 1* and *parameter 2*\n|a block|"
    source_2 = "Given a test step with *parameter 3* and *parameter 4*\n|another block|"
    source_3 = 'Given a different *parameterized* step'

    step_1 = CucumberAnalytics::Step.new(source_1)
    step_2 = CucumberAnalytics::Step.new(source_2)
    step_3 = CucumberAnalytics::Step.new(source_3)

    step_1.delimiter = '*'
    step_2.delimiter = '*'
    step_3.delimiter = '*'


    (step_1 == step_2).should be_true
    (step_1 == step_3).should be_false
  end

  context '#step_text ' do

    before(:each) do
      source = "Given a test step with -parameter 1- ^and@ *parameter 2!!\n|a block|"
      @step = CucumberAnalytics::Step.new(source)
      @step.delimiter = '-'
    end

    it 'can provide different flavors of step\'s text' do
      @step.should respond_to(:step_text)
    end

    it 'returns different text based on options' do
      (clazz.instance_method(:step_text).arity != 0).should be_true
    end

    it 'returns the step\'s text as an Array' do
      @step.step_text.is_a?(Array).should be_true
    end

    it 'returns the steps entire text by default' do
      source = "Given a test step with -parameter 1- ^and@ *parameter 2!!\n|a block|"
      step_with_block = CucumberAnalytics::Step.new(source)

      expected_output = ['Given a test step with -parameter 1- ^and@ *parameter 2!!',
                         '|a block|']

      step_with_block.step_text.should == expected_output

      source = 'Given a test step with -parameter 1- ^and@ *parameter 2!!'
      step_without_block = CucumberAnalytics::Step.new(source)

      expected_output = ['Given a test step with -parameter 1- ^and@ *parameter 2!!']

      step_without_block.step_text.should == expected_output
    end

    it 'can provide the step\'s text without the keyword' do
      expected_output = ['a test step with -parameter 1- ^and@ *parameter 2!!',
                         '|a block|']

      @step.step_text(with_keywords: false).should == expected_output
    end

    it 'can provide the step\'s text without the arguments' do
      expected_output = ['Given a test step with -- ^and@ *parameter 2!!']

      @step.step_text(with_arguments: false).should == expected_output
    end

    it 'can determine its arguments based on delimiters' do
      expected_output = ['Given a test step with -parameter 1- ^@ *parameter 2!!']

      @step.step_text(with_arguments: false, left_delimiter: '^', right_delimiter: '@').should == expected_output
    end

    it 'can use delimiters of varying lengths' do
      expected_output = ['Given a test step with -parameter 1- ^and@ *!!']

      @step.step_text(with_arguments: false, left_delimiter: '*', right_delimiter: '!!').should == expected_output
    end

    it 'can handle delimiters with special regular expression characters' do
      expected_output = ['Given a test step with -parameter 1- ^and@ *!!']

      @step.step_text(with_arguments: false, left_delimiter: '*', right_delimiter: '!!').should == expected_output
    end

  end
end
