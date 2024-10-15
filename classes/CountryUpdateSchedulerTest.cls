/**
 * Created by personal on 15.10.2024.
 */
@IsTest
public with sharing class CountryUpdateSchedulerTest {

    @IsTest
    static void testScheduleJob() {
        Test.setMock(HttpCalloutMock.class, new CountryLayerMocks.MockHttpResponse());

        String CRON_EXP = '0 0 * * * ? 2024';

        Test.startTest();
        Id jobId = System.schedule('CountryUpdateSchedulerTest', CRON_EXP, new CountryUpdateScheduler());
        Test.stopTest();

        CronTrigger ct = [
                SELECT Id,
                        CronExpression
                FROM CronTrigger
                WHERE Id = :jobId
        ];
        System.assertEquals(CRON_EXP, ct.CronExpression);
    }
}