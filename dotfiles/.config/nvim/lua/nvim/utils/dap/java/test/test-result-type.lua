local TestResultType = {
    TestStart = '%TESTS',
    TestEnd = '%TESTE',
    TestFailed = '%FAILED',
    TestError = '%ERROR',
    TraceStart = '%TRACES',
    TraceEnd = '%TRACEE',
    ExpectStart = '%EXPECTS',
    ExpectEnd = '%EXPECTE',
    ActualStart = '%ACTUALS',
    ActualEnd = '%ACTUALE',
    IGNORE_TEST_PREFIX = '@Ignore: ',
    ASSUMPTION_FAILED_TEST_PREFIX = '@AssumptionFailure: ',
}

return TestResultType
