local M = {}

function M.parse(line)
    local items = vim.split(line, "\t")

    if #items < 2 then
        return {
            type = "LogEvent",
            line = items[1],
        }
    end

    return {
        type = "ServerEvent",
        info = items[1],
        request_type = items[2],
        server_name = items[3],
        channel = items[4],
        message = items[5],
    }
end

return M
