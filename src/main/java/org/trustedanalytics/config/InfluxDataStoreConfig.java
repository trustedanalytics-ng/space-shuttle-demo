/**
 * Copyright (c) 2016 Intel Corporation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.trustedanalytics.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.trustedanalytics.storage.DataStore;
import org.trustedanalytics.storage.InfluxDataStore;
import org.trustedanalytics.storage.StoreProperties;

import java.util.HashMap;
import java.util.Map;

@Configuration
@Profile({"influx-storage", "services-all"})
public class InfluxDataStoreConfig {

    private static final Logger LOG = LoggerFactory.getLogger(InfluxDataStoreConfig.class);

    @Value("${influxdb.username}")
    private String influxUsername;

    @Value("${influxdb.password}")
    private String influxPassword;

    @Value("${influxdb.service.name}")
    private String influxHostname;

    @Value("${influxdb.port}")
    private String influxPort;

    @Bean
    public StoreProperties storeProperties() {
        Map configuration = new HashMap<String, Object>();
        configuration.put("username", influxUsername);
        configuration.put("password", influxPassword);
        configuration.put("hostname", influxHostname);
        configuration.put("port", influxPort);
        return new StoreProperties(configuration);
    }

    @Bean
    public DataStore store(StoreProperties storeProperties) {
        LOG.debug("influx config: " + storeProperties);
        LOG.info("Connecting to influxdb instance on " + storeProperties.getFullUrl());
        return new InfluxDataStore(storeProperties);
    }

}
