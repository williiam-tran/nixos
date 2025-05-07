require("spider").setup {
    skipInsignificantPunctuation = false,
    consistentOperatorPending = true, -- see "Consistent Operator-pending Mode" in the README
    subwordMovement = true,
    customPatterns = {
        overrideDefault = false,
    }
}
