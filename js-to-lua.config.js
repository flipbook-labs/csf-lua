module.exports = {
    lastSync: {
        ref: "878c4a2e10bb1f6c6838736eacc3ba6c18d910e2",
        conversionToolVersion: "5ce4081d78da1648f0d923799827c13442bcdbfb"
    },
    upstream: {
        owner: "ComponentDriven",
        repo: "csf",
        primaryBranch: "next"
    },
    downstream: {
        owner: "ghostnaps",
        repo: "csf-lua",
        primaryBranch: "main",
        patterns: [
            "src/**/*.lua"
        ]
    },
    renameFiles: [
        [
            (filename) => filename.endsWith(".test.lua"),
            (filename) => filename.replace(".test.lua", ".spec.lua")
        ],
    ]
}
