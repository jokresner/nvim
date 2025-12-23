return {
  {
    "letieu/jira.nvim",
    opts = {
      jira = {
        base = "https://your-domain.atlassian.net",
        email = "your-email@example.com",
        token = "your-api-token",
        limit = 200,
      },
      queries = {
        ["Backlog"] = "project = '%s' AND (sprint is EMPTY OR sprint not in openSprints()) AND statusCategory != Done ORDER BY Rank ASC",
        ["My Tasks"] = "assignee = currentUser() AND statusCategory != Done ORDER BY updated DESC",
      },
      projects = {
        ["MOBILE"] = {
          story_point_field = "customfield_12345", -- Custom field ID for story points
          acceptance_criteria_field = "customfield_10011", -- Custom field ID for AC
        },
      },
    },
    keys = {
      { "<leader>jb", "<cmd>Jira<cr>", desc = "Jira Board" },
    },
  },
}
