require 'json'

Puppet::Functions.create_function(:'consul_template::sorted_json') do
  # This function takes unsorted hash and outputs JSON object making sure the keys are sorted.
  # Optionally you can pass 2 additional parameters, pretty generate and indent length.
  #
  # *Examples:*
  #
  #     -------------------
  #     -- UNSORTED HASH --
  #     -------------------
  #     unsorted_hash = {
  #       'client_addr' => '127.0.0.1',
  #       'bind_addr'   => '192.168.34.56',
  #       'start_join'  => [
  #         '192.168.34.60',
  #         '192.168.34.61',
  #         '192.168.34.62',
  #       ],
  #       'ports'       => {
  #         'rpc'   => 8567,
  #         'https' => 8500,
  #         'http'  => -1,
  #       },
  #     }
  #
  #     -----------------
  #     -- SORTED JSON --
  #     -----------------
  #
  #     consul_template::sorted_json(unsorted_hash)
  #
  #     {"bind_addr":"192.168.34.56","client_addr":"127.0.0.1",
  #     "ports":{"http":-1,"https":8500,"rpc":8567},
  #     "start_join":["192.168.34.60","192.168.34.61","192.168.34.62"]}
  #
  #     ------------------------
  #     -- PRETTY SORTED JSON --
  #     ------------------------
  #     Params: data <hash>, pretty <true|false>, indent <int>.
  #
  #     consul_template::sorted_json(unsorted_hash, true, 4)
  #
  #     {
  #         "bind_addr": "192.168.34.56",
  #         "client_addr": "127.0.0.1",
  #         "ports": {
  #             "http": -1,
  #             "https": 8500,
  #             "rpc": 8567
  #         },
  #         "start_join": [
  #             "192.168.34.60",
  #             "192.168.34.61",
  #             "192.168.34.62"
  #         ]
  #     }
  #
  def sorted_json(unsorted_hash = {}, pretty = false, indent_len = 4)
    # simplify jsonification of standard types
    simple_generate = ->(obj) do
      case obj
      when NilClass, :undef
        'null'
      when Integer, Float, TrueClass, FalseClass
        obj.to_s
      else
        # Should be a string
        # keep string integers unquoted
        (obj =~ %r{/\A[-]?(0|[1-9]\d*)\z/}) ? obj : obj.to_json
      end
    end

    sorted_generate = ->(obj) do
      case obj
      when NilClass, :undef, Integer, Float, TrueClass, FalseClass, String
        return simple_generate.call(obj)
      when Array
        array_ret = []
        obj.each do |a|
          array_ret.push(sorted_generate.call(a))
        end
        return '[' << array_ret.join(',') << ']'
      when Hash
        ret = []
        obj.keys.sort.each do |k|
          ret.push(k.to_json << ':' << sorted_generate.call(obj[k]))
        end
        return '{' << ret.join(',') << '}'
      else
        raise Exception, "Unable to handle object of type #{obj.class.name} with value #{obj.inspect}"
      end
    end

    sorted_pretty_generate = ->(obj, level = 0) do
      # Indent length
      indent = ' ' * indent_len

      case obj
      when NilClass, :undef, Integer, Float, TrueClass, FalseClass, String
        return simple_generate.call(obj)
      when Array
        array_ret = []

        # We need to increase the level count before #each so the objects inside are indented twice.
        # When we come out of #each we decrease the level count so the closing brace lines up properly.
        #
        # If you start with level = 1, the count will be as follows
        #
        # "start_join": [     <-- level == 1
        #   "192.168.50.20",  <-- level == 2
        #   "192.168.50.21",  <-- level == 2
        #   "192.168.50.22"   <-- level == 2
        # ] <-- closing brace <-- level == 1
        #
        level += 1
        obj.each do |a|
          array_ret.push(sorted_pretty_generate.call(a, level))
        end
        level -= 1

        return "[\n" << (indent * (level + 1)).to_s << array_ret.join(",\n" << (indent * (level + 1)).to_s) << "\n" << (indent * level).to_s << ']'

      when Hash
        ret = []

        # This level works in a similar way to the above
        level += 1
        obj.keys.sort.each do |k|
          ret.push((indent * level).to_s << k.to_json << ': ' << sorted_pretty_generate.call(obj[k], level))
        end
        level -= 1

        return "{\n" << ret.join(",\n") << "\n" << (indent * level).to_s << '}'
      else
        raise Exception, "Unable to handle object of type #{obj.class.name} with value #{obj.inspect}"
      end
    end

    return sorted_generate.call(unsorted_hash) unless pretty
    sorted_pretty_generate.call(unsorted_hash) << "\n"
  end
end
