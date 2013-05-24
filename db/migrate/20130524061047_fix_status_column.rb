class FixStatusColumn < ActiveRecord::Migration
    def change
        rename_column :recruiters, :terms_status, :status
    end
end
