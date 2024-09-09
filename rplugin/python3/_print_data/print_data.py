import pynvim
import pprint


@pynvim.plugin
class Print(object):
    def __init__(self, nvim):
        self.nvim = nvim

    @pynvim.command("PrintDict")
    def print_dict(self, nargs="*"):
        python_data_type = {"a": [1, 2, 3], "b": {"x": 10, "y": 20}}
        pp = pprint.PrettyPrinter(indent=4)
        result = pp.pformat(python_data_type) + "\n"
        self.nvim.out_write(result)

    @pynvim.command("PrintStringList")
    def print_string_list(self, nargs="*"):
        string_list = ["hello", "world", "from", "python"]
        self.nvim.out_write(repr(string_list) + "\n")
        self.nvim.out_write(str(string_list) + "\n")
        self.nvim.out_write(", ".join(string_list) + "\n")
        self.nvim.out_write("\n".join(string_list) + "\n")

    @pynvim.command("PrintDeepNestedLuaTable")
    def print_deep_nested_lua_table(self, nargs="*"):
        self.nvim.exec_lua("""
        vim.g.deep_nest = {
            personal = {
                name = "John Doe",
                age = 30,
                hobbies = {"reading", "cycling", "photography"},
            },
            work = {
                company = "Tech Corp",
                position = "Developer",
                skills = {
                    programming = {"Lua", "Python", "JavaScript"},
                    tools = {"Git", "Docker"},
                },
            },
        }
        """)
        result = self.nvim.command_output(":lua vim.print(vim.g.deep_nest)")
        self.nvim.out_write(result + "\n")
