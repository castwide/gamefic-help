# frozen_string_literal: true

RSpec.describe Gamefic::Help do
  let(:plot) do
    Class.new(Gamefic::Plot) do
      include Gamefic::Help

      script do
        respond(:foo) {}

        respond(:bar) {}

        explain :foo, 'Foo all the stuff.'

        respond(:baz) {}

        explain :baz, 'Baz all the stuff.'

        interpret 'synonym foo', 'foo'
        interpret 'synonym baz', 'baz'
      end
    end
    .new
  end

  let(:player) do
    player = plot.introduce
    player
  end

  it 'has a version number' do
    expect(Gamefic::Help::VERSION).not_to be nil
  end

  it 'displays a list of commands' do
    player.perform 'help'
    plot.rulebook.synonyms.each do |syn|
      expect(player.messages).to include(syn.to_s)
    end
  end

  it 'displays command details' do
    plot.rulebook.synonyms.each do |syn|
      player.perform "help #{syn}"
      expect(player.messages).to include(syn.to_s)
      player.flush
    end
  end

  it 'asks for a simple command' do
    player.perform 'help me do a thing'
    expect(player.messages).to include('specific command')
  end

  it 'reports unknown verbs' do
    player.perform 'help unknown'
    expect(player.messages).to include('not a verb I understand')
  end

  it 'includes explanations' do
    player.perform 'help foo'
    expect(player.messages).to include('Foo all the stuff.')
  end

  it 'lists multiple explanations and examples for synonyms' do
    player.perform 'help synonym'
    expect(player.messages).to include('Foo all the stuff.')
    expect(player.messages).to include('Baz all the stuff.')
    expect(player.messages).to include('Examples:')
    expect(player.messages).to include('synonym foo')
    expect(player.messages).to include('synonym baz')
  end
end
