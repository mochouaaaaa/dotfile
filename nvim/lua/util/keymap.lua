-- 判断系统类型
function is_mac()
    return vim.fn.has("mac") == 1
end

return {
    -- 根据系统类型映射按键
    -- @param key string
    -- cmd: command
    -- option: option
    -- @return string
    platform_key = {
        cmd = "<D",
        option = "<A",
    },
    is_mac = is_mac,
    is_linux = function()
        return vim.fn.has("unix") == 1 and vim.fn.has("linux") == 1
    end,
}
