# frozen_string_literal: true

require 'gamefic'
require 'gamefic/help/version'

module Gamefic
  module Help
    extend Gamefic::Scriptable

    # Get or set an explanation for a verb the plot understands.
    #
    # @param verb [Symbol]
    # @param description [String, nil]
    # @return [String, nil]
    def explain verb, description = nil
      @gamefic_help_verb_explanations ||= {}
      @gamefic_help_verb_explanations[verb] = description unless description.nil?
      @gamefic_help_verb_explanations[verb]
    end

    script do
      meta :verbs do |actor|
        list = rulebook.synonyms.reject { |syn| syn.to_s.start_with?('_') }
                      .map { |syn| "<kbd>#{syn}</kbd>"}
                      .join_and
        actor.tell 'Try using commands in plain sentences like <kbd>go north</kbd> or <kbd>take the coin</kbd>.'
        actor.tell 'For more information about a specific command, try <kbd>help [command]</kbd>, e.g., <kbd>help go</kbd>.'
        actor.tell "I understand the following commands: #{list}."
      end

      interpret 'commands', 'verbs'
      interpret 'help', 'verbs'

      meta :help, plaintext do |actor, command|
        if rulebook.synonyms.include?(command.to_sym) && !command.start_with?('_')
          available = rulebook.syntaxes.select { |syntax| syntax.synonym == command.to_sym }
                              .uniq(&:signature)

          verbs = available.map(&:verb).uniq

          explanations = verbs.map { |verb| explain(verb.to_sym) }.compact

          if explanations.one?
            actor.tell explanations.first
          elsif explanations.any?
            actor.stream '<ul>'
            explanations.each do |expl|
              actor.stream "<li>#{expl}</li>"
            end
            actor.stream '</ul>'
          end

          examples = available.map(&:template)
                              .map do |tmpl|
                                tmpl.text
                                    .gsub(/:character/i, '[someone]')
                                    .gsub(/:var[0-9]?/i, '[something]')
                                    .gsub(/:([a-z0-9]+)/i, "[\\1]")
                              end
                              .reject { |tmpl| tmpl.include?('[something] [something]') }

          if explanations.empty? && examples.length < 2
            actor.tell "No further help is available for <kbd>#{command}</kbd>."
            next
          end

          actor.tell 'Examples:'
          actor.stream '<ul>'
          examples.each do |xmpl|
            actor.stream "<li><kbd>#{xmpl}</kbd></li>"
          end
          actor.stream '</ul>'
          related = verbs.that_are_not(command.to_sym)
                         .sort
                         .map { |sym| "<kbd>#{sym}</kbd>"}
          next if related.empty?

          actor.tell "Related: #{related.join(', ')}"
        elsif command =~ /[^a-z]/i
          actor.tell 'Try asking for help with a specific command, e.g., <kbd>help go</kbd>.'
        else
          actor.tell "\"#{command.cap_first}\" is not a verb I understand."
        end
      end
    end
  end
end
