module RedmineCategoryTree
	module Patches
		module IssueCategoryPatch
			def self.prepended(base) # :nodoc:
				base.extend(ClassMethods)
				base.class_eval do
					safe_attributes 'parent_id'
					acts_as_nested_set :order => "name", :dependent => :destroy, :scope => 'project_id'
				end
			end

			module ClassMethods
				def issue_category_tree(issue_categories, &block)
					ancestors = []
					issue_categories.sort_by {|c| c[:lft].to_i }.each do |category|
						while (ancestors.any? && !category.is_descendant_of?(ancestors.last))
							ancestors.pop
						end
						yield category, ancestors.size
						ancestors << category
					end
				end
			end
		end
	end
end
