# frozen_string_literal: true

RSpec.describe Gamefic::Help do
  let(:plot) do
    Class.new(Gamefic::Plot) do
      include Gamefic::Help

      script do
        respond(:foo) {}

        respond(:bar) {}
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
      expect(player.messages).to include('Examples:')
      player.flush
    end
  end
end
