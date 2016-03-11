module MainModule
  @@displayView = nil
  @@resultView = nil

  @@isCmdOrOpeClicked = true

  @@isError = false

  @@audioPlayer = nil

  @@audioHash = nil

  def self.getAudioPlayer
    @@audioPlayer
  end

  def self.setAudioPlayer(x)
    @@audioPlayer = x
  end

  def self.getAduioHash
    @@audioHash
  end

  def self.setAudioHash(x)
    @@audioHash = x
  end

  def self.get
    @@displayView
  end

  def self.set(x)
    @@displayView = x
  end

  def self.getResult
    @@resultView
  end

  def self.setResult(x)
    @@resultView = x
  end

  def self.getIsCmdOrOpeClicked
    @@isCmdOrOpeClicked
  end

  def self.setIsCmdOrOpeClicked(x)
    @@isCmdOrOpeClicked = x
  end

  def self.getIsError
    @@isError
  end

  def self.setIsError(x)
    @@isError = x
  end

end

class MainActivity < Android::App::Activity
  DISPLAYHASH = {
  R::Id::Img_cal_d0 => '0',
  R::Id::Img_cal_d1 => '1',
  R::Id::Img_cal_d2 => '2',
  R::Id::Img_cal_d3 => '3',
  R::Id::Img_cal_d4 => '4',
  R::Id::Img_cal_d5 => '5',
  R::Id::Img_cal_d6 => '6',
  R::Id::Img_cal_d7 => '7',
  R::Id::Img_cal_d8 => '8',
  R::Id::Img_cal_d9 => '9',
  R::Id::Img_cal_add => '+',
  R::Id::Img_cal_minus => '-',
  R::Id::Img_cal_multiply => '*',
  R::Id::Img_cal_div => '/',
  R::Id::Img_cal_dot => '.' }

  ID_AUDIO = {
    R::Id::Img_cal_d0 => 'zero',
    R::Id::Img_cal_d1 => 'one',
    R::Id::Img_cal_d2 => 'two',
    R::Id::Img_cal_d3 => 'three',
    R::Id::Img_cal_d4 => 'four',
    R::Id::Img_cal_d5 => 'five',
    R::Id::Img_cal_d6 => 'six',
    R::Id::Img_cal_d7 => 'seven',
    R::Id::Img_cal_d8 => 'eight',
    R::Id::Img_cal_d9 => 'nine',
    R::Id::Img_cal_add => 'add',
    R::Id::Img_cal_minus => 'minus',
    R::Id::Img_cal_multiply => 'multiply',
    R::Id::Img_cal_div => 'div',
    R::Id::Img_cal_dot => 'point',
    R::Id::Img_cal_c => 'clear',
    R::Id::Img_cal_del => 'del',
    R::Id::Img_cal_amount => 'equal'}

  @displayText = ''

  class << self
    attr_accessor :displayText
  end

  def onCreate(savedInstanceState)
	  super
    self.contentView = resources.getIdentifier('main', 'layout', 'com.caculator.chenzp')
    MainModule.set(findViewById(R::Id::Input_typebox))
    MainModule.setResult(findViewById(R::Id::Result_textview))

    MainModule.setAudioPlayer(Android::Media::SoundPool.new(1, 3, 0))
    loadAudio

    @numListener = BtnNumListener.new
    @opeListener = BtnOpeListener.new
    @cmdListener = BtnCmdListener.new
    initListener
  end

  def getDisplayView()
    return @displayView
  end

  def loadAudio()
    audioMap = {}
    audioList = %w{ zero one two three four five six seven
      eight nine ten point add minus multiply div equal clear del}
    audioList.each {|digit| audioMap[digit] = MainModule.getAudioPlayer.load(self, resources.getIdentifier(digit, 'raw', 'com.caculator.chenzp'), 1) }
    MainModule.setAudioHash(audioMap)
  end

  def initListener()
    numIdList = [R::Id::Img_cal_d0, R::Id::Img_cal_d1, R::Id::Img_cal_d2,
    R::Id::Img_cal_d3, R::Id::Img_cal_d4, R::Id::Img_cal_d5,
    R::Id::Img_cal_d6, R::Id::Img_cal_d7, R::Id::Img_cal_d8,
    R::Id::Img_cal_d9]
    numIdList.each {|numId| findViewById(numId).setOnClickListener(@numListener)}

    opeIdList = [R::Id::Img_cal_add, R::Id::Img_cal_minus, R::Id::Img_cal_multiply,
    R::Id::Img_cal_div, R::Id::Img_cal_dot]
    opeIdList.each {|opeId| findViewById(opeId).setOnClickListener(@opeListener)}

    cmdIdList = [R::Id::Img_cal_c, R::Id::Img_cal_del, R::Id::Img_cal_amount]
    cmdIdList.each {|cmdId| findViewById(cmdId).setOnClickListener(@cmdListener)}

  end


end

class BtnNumListener
  def onClick(view)
    puts 'click in lisnter...'
    musicName = MainActivity::ID_AUDIO[view.getId]
    MainModule.getAudioPlayer.play(MainModule.getAduioHash[musicName], 1, 1, 1, 0, 1)
    MainActivity.displayText = MainActivity.displayText + MainActivity::DISPLAYHASH[view.getId]
    MainModule.get.setText(MainActivity.displayText)
    puts 'num ' + MainActivity.displayText
    MainModule.getResult.setText(EvalString.new.evalResult(MainActivity.displayText))
    if MainModule.getIsError
      MainModule.getResult.setText('ERROR')
      MainModule.setIsError(false)
    end
    MainModule.setIsCmdOrOpeClicked(false)
  end
end

class BtnOpeListener
  def onClick(view)
    puts 'ope click...'
    if MainModule.getIsCmdOrOpeClicked
      return
    end
    musicName = MainActivity::ID_AUDIO[view.getId]
    back = MainModule.getAudioPlayer.play(MainModule.getAduioHash[musicName], 1, 1, 1, 0, 1)
    MainActivity.displayText = MainActivity.displayText + MainActivity::DISPLAYHASH[view.getId]
    MainModule.get.setText(MainActivity.displayText)
    # MainModule.get.setText('\u00d7')
    MainModule.setIsCmdOrOpeClicked(true)
  end
end

class BtnCmdListener
  def onClick(view)
    puts 'cmd click...'
    musicName = MainActivity::ID_AUDIO[view.getId]
    back = MainModule.getAudioPlayer.play(MainModule.getAduioHash[musicName], 1, 1, 1, 0, 1)
    case view.getId
    when R::Id::Img_cal_c
      MainActivity.displayText = ''
      MainModule.get.setText('')
      MainModule.getResult.setText('0')
      MainModule.setIsCmdOrOpeClicked(true)
    when R::Id::Img_cal_del
      case MainActivity.displayText.size
      when 0
        return
      when 1
        MainActivity.displayText = ''
        MainModule.get.setText('')
        MainModule.getResult.setText('0')
        MainModule.setIsCmdOrOpeClicked(true)
      else
        MainActivity.displayText = MainActivity.displayText[0..-2]
        MainModule.get.setText(MainActivity.displayText)
        lastOne = MainActivity.displayText[-1]
        if ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'].include? lastOne
          MainModule.getResult.setText(EvalString.new.evalResult(MainActivity.displayText))
          MainModule.setIsCmdOrOpeClicked(false)
          if MainModule.getIsError
             MainModule.getResult.setText('ERROR')
             MainModule.setIsError(false)
          end
        elsif ['+', '-', '*', '/', '.'].include? lastOne
          MainModule.setIsCmdOrOpeClicked(true)
        end
      end
    when R::Id::Img_cal_amount
      MainActivity.displayText = ''
      MainModule.get.setText('')
      MainModule.setIsCmdOrOpeClicked(true)
    end

  end

end

class EvalString
  OP_PRIORITY = {'+' => 0, '-' => 0, '*' => 1, '/' => 1}
  OP_FUNCTION = {
    "+" => lambda {|x, y| x + y},
    "-" => lambda {|x, y| x - y},
    "*" => lambda {|x, y| x * y},
    "/" => lambda {|x, y| x / y} }

  def isOperator(x)
    ['+', '-', '*', '/'].include? x
  end

  def isLeqPriority(a, b)
    OP_PRIORITY[a] - OP_PRIORITY[b]
  end

  def toSuffix(s)
    resultStack = []
    opStack = []
    tokens = s.scan(/\d+\.\d+|\d+|\+|-|\*|\//)
    tokens.each do |token|
      if !isOperator(token)
        resultStack.push(token)
      else
        topToken = opStack[-1]
        while topToken && isLeqPriority(topToken, token) >= 0
          resultStack.push(opStack.pop)
          topToken = opStack[-1]
        end
        opStack.push(token)
      end
    end
    while opStack.size > 0
      resultStack.push(opStack.pop)
    end
    return resultStack
  end

  def evalResult(s)
    digitStack = []
    suffixTokens = toSuffix(s)
    suffixTokens.each do |token|
      if !isOperator(token)
        digitStack.push(token)
      else
        a = digitStack.pop.to_f
        b = digitStack.pop.to_f
        if token == '/' && a.to_i == 0
          puts 'error'
          MainModule.setIsError(true)
          return ''
        end
        digitStack.push(OP_FUNCTION[token].call(b, a))
      end
    end
    result = digitStack.pop
    if result == result.to_i
      result = result.to_i
    end
    return result.to_s
  end

end
