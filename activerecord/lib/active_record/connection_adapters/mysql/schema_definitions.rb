module ActiveRecord
  module ConnectionAdapters
    module MySQL
      module ColumnMethods
        def primary_key(name, type = :primary_key, **options)
          options[:auto_increment] = true if [:integer, :bigint].include?(type) && !options.key?(:default)
          super
        end

        def blob(*args, **options)
          args.each { |name| column(name, :blob, options) }
        end

        def tinyblob(*args, **options)
          args.each { |name| column(name, :tinyblob, options) }
        end

        def mediumblob(*args, **options)
          args.each { |name| column(name, :mediumblob, options) }
        end

        def longblob(*args, **options)
          args.each { |name| column(name, :longblob, options) }
        end

        def tinytext(*args, **options)
          args.each { |name| column(name, :tinytext, options) }
        end

        def mediumtext(*args, **options)
          args.each { |name| column(name, :mediumtext, options) }
        end

        def longtext(*args, **options)
          args.each { |name| column(name, :longtext, options) }
        end

        def json(*args, **options)
          args.each { |name| column(name, :json, options) }
        end

        def unsigned_integer(*args, **options)
          args.each { |name| column(name, :unsigned_integer, options) }
        end

        def unsigned_bigint(*args, **options)
          args.each { |name| column(name, :unsigned_bigint, options) }
        end

        def unsigned_float(*args, **options)
          args.each { |name| column(name, :unsigned_float, options) }
        end

        def unsigned_decimal(*args, **options)
          args.each { |name| column(name, :unsigned_decimal, options) }
        end

        def geometry(*args, **options)
          args.each { |name| column(name, :geometry, options) }
        end

        def point(*args, **options)
          args.each { |name| column(name, :point, options) }
        end

        def linestring(*args, **options)
          args.each { |name| column(name, :linestring, options) }
        end

        def polygon(*args, **options)
          args.each { |name| column(name, :polygon, options) }
        end

      end

      class ColumnDefinition < ActiveRecord::ConnectionAdapters::ColumnDefinition
        attr_accessor :charset, :unsigned, :stored
      end

      class TableDefinition < ActiveRecord::ConnectionAdapters::TableDefinition
        include ColumnMethods

        def new_column_definition(name, type, options) # :nodoc:
          case type
          when :virtual
            type = options[:type]
          when :primary_key
            type = :integer
            options[:limit] ||= 8
            options[:auto_increment] = true
            options[:primary_key] = true
          when /\Aunsigned_(?<type>.+)\z/
            type = $~[:type].to_sym
            options[:unsigned] = true
          end
          column = super
          column.unsigned = options[:unsigned]
          column.charset = options[:charset]
          column.stored = options[:stored]
          column
        end

        private

          def create_column_definition(name, type)
            MySQL::ColumnDefinition.new(name, type)
          end
      end

      class Table < ActiveRecord::ConnectionAdapters::Table
        include ColumnMethods
      end
    end
  end
end
