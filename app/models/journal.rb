class Journal < ApplicationRecord

    def self.info( user_id, journal_type)
        find_by( user_id: user_id, journal_type: journal_type)
    end

end
