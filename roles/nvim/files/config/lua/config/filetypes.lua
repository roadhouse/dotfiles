vim.filetype.add({
  pattern = {
    [".*/templates/.*%.yaml"] = "helm",
    [".*/templates/.*%.yml"] = "helm",
    ["helmfile.*%.yaml"] = "helm",
    ["Chart%.yaml"] = "helm",
    ["values.*%.yaml"] = "helm",
  },
})
