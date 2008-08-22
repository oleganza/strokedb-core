module StrokeDB
  module InheritableAttributes
    UUID_78f4156b_f3cb_55e8_9083_680ed199f277 = "78f4156b_f3cb_55e8_9083_680ed199f277".freeze
    
    def define_inheritable_attribute(name)
      uuid = UUID_78f4156b_f3cb_55e8_9083_680ed199f277
      @names_78f4156b_f3cb_55e8_9083_680ed199f277 ||= []
      @names_78f4156b_f3cb_55e8_9083_680ed199f277 << name
      @names_78f4156b_f3cb_55e8_9083_680ed199f277.uniq!
      ivar_cache         = "@#{name}_children_#{uuid}_cache"
      ivar_children      = "@#{name}_children_#{uuid}"
      ivar_children_get  = "instance_variable_get(:#{ivar_children})"
      ivar_children_set_ = "instance_variable_set(:#{ivar_children}"
      meta_class = (class <<self; self; end)
      meta_class.module_eval(code = <<-EVAL, __FILE__, __LINE__)
        def #{name}
          @#{name}
        end
        def #{name}=(v)
          @#{name} = v
          # Invalidate all inherited ivars instead of the needed one. 
          # The code is already messy, so i don't even try to be THAT smartass.
          invalidate_children_78f4156b_f3cb_55e8_9083_680ed199f277
          v
        end
        def #{name}_inherited
          #{ivar_cache} ||= ancestors.inject([]) do |memo, ancestor|
            c = ancestor.#{ivar_children_get}
            ancestor.#{ivar_children_set_}, ((c || []) << self).uniq)
            ancestor.extend(StrokeDB::InheritableAttributes)
            if ivar = ancestor.instance_variable_get(:@#{name})
              memo.push(ivar) 
            end
            memo
          end
        end
      EVAL
    end
    
    def include(mod)
      invalidate_children_78f4156b_f3cb_55e8_9083_680ed199f277
      super
    end
    
    def included(sub)
      sub.extend(StrokeDB::InheritableAttributes)
      (@names_78f4156b_f3cb_55e8_9083_680ed199f277 || []).each do |name|
        sub.define_inheritable_attribute(name)
      end
      super
    end
    
    def invalidate_children_78f4156b_f3cb_55e8_9083_680ed199f277(mod = self)
      uuid = UUID_78f4156b_f3cb_55e8_9083_680ed199f277
      mod.instance_variables.grep(/children_#{uuid}$/) do |ivar|
        (mod.instance_variable_get(ivar) || []).each do |child|
          child.instance_variable_set("#{ivar}_cache", nil)
        end
      end
    end
    
  end # InheritableAttributes
  
  # Don't pollute globals. See line 28.
  #
  # class ::Module
  #   include StrokeDB::InheritableAttributes
  # end
  
end # StrokeDB
