def scriptApproval = org.jenkinsci.plugins.scriptsecurity.scripts.ScriptApproval.get()

String[] signs = [
    "method java.time.temporal.Temporal plus long java.time.temporal.TemporalUnit",
    "method java.time.temporal.Temporal with java.time.temporal.TemporalAdjuster",
    "method java.time.temporal.TemporalAccessor get java.time.temporal.TemporalField",
    "staticField java.time.temporal.ChronoUnit DAYS",
    "staticField java.time.temporal.IsoFields WEEK_OF_WEEK_BASED_YEAR"
    ]

for( String sign : signs ) {
    scriptApproval.approveSignature(sign)
}

scriptApproval.save()

