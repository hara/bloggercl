# coding: utf-8

require File.expand_path('../spec_helper', __FILE__)

describe BloggerCL::Session do
  describe '#path' do
    context 'when initialized with a path' do
      it 'returns the specified path' do
        path = File.expand_path('../session', __FILE__)
        session = BloggerCL::Session.new(path)
        session.path.should eq(path)
      end
    end

    context 'when initialized without path' do
      it 'returns the default path' do
        path = File.expand_path('~/.bloggercl')
        session = BloggerCL::Session.new
        session.path.should eq(path)
      end
    end
  end

  describe '#load' do
    context 'when session exists' do
      before do
        @dir = File.expand_path('../session', __FILE__)
        @path = File.join(@dir, 'session_default')
        @session = BloggerCL::Session.new(@dir)
        @session.commit(:default, {:message => 'hello'})
      end

      after do
        File.delete(@path) if File.exist?(@path)
      end

      context 'given a session id' do
        it 'loads session from dumped data' do
          @session.load(:default).should eq({:message => 'hello'})
        end
      end

      context 'given a session id and block' do
        it 'calls block with session data' do
          @session.load(:default) do |session|
            session.should eq({:message => 'hello'})
          end
        end

        it 'commits after callback' do
          @session.load(:default) do |session|
            session[:message] = 'hello,hello'
          end
          File.open(@path) do |f|
            Marshal.load(f).should eq({:message => 'hello,hello'})
          end
        end
      end
    end

    context 'when session does not exist' do
      before do
        @dir = File.expand_path('../session', __FILE__)
        @path = File.join(@dir, 'session_default')
        @session = BloggerCL::Session.new(@dir)
      end

      after do
        File.delete(@path) if File.exist?(@path)
      end

      context 'given a session id' do
        it 'creates empty session' do
          @session.load(:default).should eq({})
        end
      end
    end
  end

  describe '#commit' do
    before do
      @dir = File.expand_path('../session', __FILE__)
      @path = File.join(@dir, 'session_default')
      File.delete(@path) if File.exist?(@path)
      @session = BloggerCL::Session.new(@dir)
    end

    after do
      File.delete(@path) if File.exist?(@path)
    end

    it 'dumps session data to a file' do
      @session.commit(:default, {:message => 'hello'})
      File.open(@path) do |f|
        Marshal.load(f).should eq({:message => 'hello'})
      end
    end
  end
end
