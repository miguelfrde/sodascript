require 'terminal-table'
require 'sodascript/grammar'

module Sodascript

  ##
  # This class is an abstraction of the SLR table used by the SLR Parser when
  # trying to accept a set of tokens.

  class SLRTable

    # Shift action representation
    SHIFT = :shift

    # Reduce action representation
    REDUCE = :reduce

    # Accept action representation
    ACCEPT = :accept

    ##
    # Create a new table by specifying the terminals and non-terminals that it
    # will use.

    def initialize(terminals, non_terminals)
      @goto_table = {}
      @action_table = {}
      @terminals = terminals
      @non_terminals = non_terminals
    end

    ##
    # Add a reduce action from a state to another state with a specified
    # symbol

    def shift(from_state, symbol, to_state)
      check_for_conflict(@action_table, from_state, symbol,to_state, SHIFT)
      check_for_conflict(@goto_table, from_state, symbol, to_state, SHIFT)  

      if @non_terminals.include?(symbol)
        (@goto_table[from_state] ||= {})[symbol] = to_state
      elsif @terminals.include?(symbol)
        (@action_table[from_state] ||= {})[symbol] = [SHIFT, to_state]
      else
        raise ArgumentError, 'symbol must be a terminal or a non-terminal'
      end
    end

    ##
    # Add a reduce action from a state to a production with a specified
    # terminal

    def reduce(from_state, symbol, prod_index)
      check_for_conflict(@action_table, from_state, symbol, prod_index, REDUCE)
      raise ArgumentError, 'symbol must be a terminal' unless
        @terminals.include?(symbol)

      (@action_table[from_state] ||= {})[symbol] = [REDUCE, prod_index]
    end

    ##
    # Add an accept action to a state with a specified terminal

    def accept(state, symbol)
      raise ArgumentError, 'symbol must be a terminal' unless 
        @terminals.include?(symbol) 
      (@action_table[state] ||= {})[symbol] = ACCEPT
    end

    ##
    # Get the action defined for a state with a terminal

    def action(from_state, symbol)
      return unless @action_table[from_state]
      @action_table[from_state][symbol]
    end

    ##
    # Get the action defined for a state with a non-terminal

    def goto(from_state, symbol)
      return unless @goto_table[from_state]
      @goto_table[from_state][symbol]
    end

    ##
    # String representation of the SLR table

    def to_s
      table = Terminal::Table.new do |t|
        symbols = @terminals.size + @non_terminals.size
        t << ['State'] + @terminals.to_a + @non_terminals.to_a

        max_state = [@goto_table.size, @action_table.size].max - 1
        (0..max_state).each do |state|
          t.add_separator
          row = [state]
          @terminals.each { |sym| row << (action_str(state, sym) || ' ') }
          @non_terminals.each { |sym| row << (goto(state, sym) || ' ') }
          t << row
        end
      end
      table.to_s
    end

    private

    ##
    # Used by to_s to obtain the string representation of an action. If the
    # action is reduce, then it returns r<n>, if it's shift it returns s<n>

    def action_str(state, symbol)
      return unless action(state, symbol)
      return 'acc' if action(state, symbol) == ACCEPT
      a, n = action(state, symbol)
      s = (a == SHIFT && 's') || (a == REDUCE && 'r')
      "#{s}#{n}"
    end

    ##
    # Checks if there's a shift/reduce condlict on the given table

    def check_for_conflict(table, from_state, symbol, to_state, action)
      a_name = action.to_s.downcase
      if table.has_key?(from_state) &&
          table[from_state].has_key?(symbol) &&
          table[from_state][symbol] != [action, to_state]
        act, _ = table[from_state][symbol]
        raise ArgumentError, "shift/#{a_name} conflict on #{from_state} with #{symbol}" if
          act == SHIFT
        raise ArgumentError, "#{a_name}/reduce conflict on #{from_state} with #{symbol}" if 
          act == REDUCE
      end
    end
  end
end
