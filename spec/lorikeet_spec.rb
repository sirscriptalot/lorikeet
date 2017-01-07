require          'minitest/autorun'
require_relative '../lib/lorikeet'

class Counter
  attr_reader :count

  def initialize(count = 0)
    @count = 0
  end

  def increment
    @count += 1
  end

  def decrement
    @count -= 1
  end
end

class Observer
  include Lorikeet::Observer

  attr_reader :received

  def callback(counter)
    @received = counter
  end

  def receive(counter)
    @received = counter
  end
end

describe 'Lorikeet::Observable' do
  before do
    @observable = Lorikeet::Observable.new(Counter.new)
    @observer   = Observer.new
  end

  describe '#include?' do
    it 'returns bool for if observer is in observers' do
      refute @observable.include?(@observer)

      @observable.instance_variable_set(:@observers, [@observer])

      assert @observable.include?(@observer)
    end
  end

  describe '#<<' do
    it 'adds the observer if it does not exist' do
      refute @observable.include?(@observer)

      @observable << @observer

      assert @observable.include?(@observer)
    end
  end

  describe '#delete' do
    it 'removes the observer from observers' do
      @observable << @observer

      assert @observable.include?(@observer)

      @observable.delete(@observer)

      refute @observable.include?(@observer)
    end
  end

  describe '#action' do
    before do
      @observer.observe(@observable)

      @observable.action do |context|
        @context = context
      end
    end

    it 'passes context to the given block' do
      assert @context == @observable.instance_variable_get(:@context)
    end

    it 'passes context to observer callbacks' do
      assert @observer.received == @observable.instance_variable_get(:@context)
    end
  end
end

describe 'Lorikeet::Observer' do
  before do
    @observable = Lorikeet::Observable.new(Counter.new)
    @observer   = Observer.new
  end

  describe '#observe' do
    it 'adds self to the observable\'s observers' do
      @observer.observe @observable

      assert @observable.include?(@observer)
    end

    it 'sets the callback_id if provided' do
      @observer.observe @observable

      assert @observer.callback_id == Lorikeet::Observer::DEFAULT_CALLBACK_ID

      @observer.observe @observable, :custom_callback_id

      assert @observer.callback_id == :custom_callback_id
    end
  end

  describe '#callback_id' do
    it 'returns DEFAULT_CALLBACK_ID when nil' do
      @observer.instance_variable_set(:@callback_id, nil)

      assert @observer.callback_id == Lorikeet::Observer::DEFAULT_CALLBACK_ID
    end
  end
end
