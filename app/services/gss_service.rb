require 'google_drive'

class GssService
    def initialize
        @session = GoogleDrive::Session.from_service_account_key("config/gss_service_account.json")
        @spreadsheet = @session.spreadsheet_by_title("test_gss")
        @worksheet = @spreadsheet.worksheets.first
    end

    def import_data
        @result = @worksheet.rows.map do |id, name|
            { id: id, name: name }
        end
    end

    def export_data(data_array)
        data_array.each_with_index do |row_data, index|
            row_data.each_with_index do |cell, col_index|
            @worksheet[index + 1, col_index + 1] = cell
            end
        end
        @worksheet.save
    end
end