module DbTextSearch
  class CaseInsensitiveStringFinder
    class LowerAdapter
      # @param [ActiveRecord::Relation, Class<ActiveRecord::Base>] scope
      # @param [Symbol] column name
      def initialize(scope, column)
        @scope  = scope
        @column = column
      end

      # @param [Array<String>] values
      # @return [ActiveRecord::Relation]
      def find(values)
        conn = @scope.connection
        @scope.where <<-SQL
          LOWER(#{conn.quote_table_name(@scope.table_name)}.#{conn.quote_column_name(@column)})
            IN (#{values.map { |v| "LOWER(#{conn.quote(v.to_s)})" }.join(', ')})
        SQL
      end
    end
  end
end
