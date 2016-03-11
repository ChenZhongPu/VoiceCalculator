# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/android'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = '语音计算器' 
  app.package = "com.caculator.chenzp"
  app.theme = "@android:style/Theme.NoTitleBar"
  app.icon = "icon"
  app.release_keystore(File.expand_path("~/android.keystore"), "chenandorid")
  app.version_code = "2"
  app.version_name = "1.2"

end
