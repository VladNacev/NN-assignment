/**
 * Created by personal on 15.10.2024.
 */

public with sharing class CountryUpdateScheduler implements Schedulable {
    public void execute(SchedulableContext context) {
        CountryLayerHandler.upsertCountriesFromCountryLayer();
    }
}