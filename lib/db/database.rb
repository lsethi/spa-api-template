require 'sqlite3'

module AwsumLink
  class Database
    def initialize
      @db = SQLite3::Database.new 'awsumlink.db'
      @db.results_as_hash = true
      puts @db.get_first_value 'SELECT SQLITE_VERSION()'
    end

    # Strips out indexes from sqlite hash passed to it (pretty sure I
    # can assume that we're never going to just name a column a number)
    def sanitize_sqlite_hash row
      row.delete_if do |key|
        key.is_a? Integer
      end
      return row
    end

    # Same as above, but for multiple results returned in an array
    def sanitize_sqlite_hash_array array
      results = []
      array.each do |row|
        results << self.sanitize_sqlite_hash(row)
      end
      return results
    end

    public
    # User Methods
    def create_user username, password
      begin
        @db.execute "INSERT INTO users(username, password) VALUES('#{username}', '#{password}')"
        return true
      rescue SQLite3::Exception => e
        return e
      end
    end

    def get_user id_or_name
      if id_or_name.is_a? String
        db_hash = (@db.execute "SELECT * FROM users WHERE username='#{id_or_name}'")[0]
      elsif id_or_name.is_a? Integer
        db_hash = (@db.execute "SELECT * FROM users WHERE id=#{id_or_name}")[0]
      end

      return self.sanitize_sqlite_hash db_hash
    end

    def get_all_users
      return self.sanitize_sqlite_hash_array @db.execute "SELECT * FROM users"
    end

    def delete_user id
      begin
        @db.execute "DELETE FROM users WHERE id=#{id}"
        return true
      rescue SQLite3::Exception => e
        return e
      end
    end

    # List Methods
    def get_all_lists
      return self.sanitize_sqlite_hash_array @db.execute "SELECT * FROM lists"
    end

    def get_lists_from_user id
      return self.sanitize_sqlite_hash_array @db.execute "SELECT * FROM lists WHERE user_id=#{id}"
    end

    def get_list id
      return self.sanitize_sqlite_hash (@db.execute "SELECT * FROM lists WHERE id=#{id}")[0]
    end

    def create_list user_id, name
      begin
        timestamp = Time.now.to_i
        @db.execute "INSERT INTO lists(user_id, name, last_updated) VALUES(#{user_id}, \"#{name}\", #{timestamp})"
        return true
      rescue SQLite3::Exception => e
        return e
      end
    end

    def delete_list id
      begin
        @db.execute "DELETE FROM lists WHERE id=#{id}"
        return true
      rescue SQLite3::Exception => e
        return e
      end
    end

    # Links Methods
    def get_links_from_list id
      return self.sanitize_sqlite_hash_array @db.execute "SELECT * FROM links WHERE list_id=#{id}"
    end

    def get_link id
      return self.sanitize_sqlite_hash (@db.execute "SELECT * FROM links WHERE id=#{id}")[0]
    end

    def create_link list_id, url, name, description
      begin
        timestamp = Time.now.to_i
        @db.execute "INSERT INTO links(list_id, url, name, description, last_updated)"\
                    "VALUES(#{list_id}, '#{url}', '#{name}', '#{description}', #{timestamp})"
        return true
      rescue SQLite3::Exception => e
        return e
      end
    end

    def update_link id, params
      # TODO: implement last_updated for parent list as well
      begin
        timestamp = Time.now.to_i
        query     = "UPDATE links SET "
        puts params
        [:url, :name, :description].each do |key|
          if params.has_key?(key.to_s)
            query += "#{key.to_s}='#{params[key]}', "
          end
        end
        # Strip trailing ", "
        query = query[0..-3] + " WHERE id=#{id}"
        puts query
        @db.execute query
        return true
      rescue SQLite3::Exception => e
        return e
      end
    end

    def delete_link id
      @db.execute "DELETE FROM links WHERE id=#{id}"
    end
  end

  def self.db
    @db ||= AwsumLink::Database.new
  end
end
