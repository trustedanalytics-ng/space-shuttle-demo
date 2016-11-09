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
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.trustedanalytics.dataproviders.RandomDataProvider;
import org.trustedanalytics.process.DataConsumer;

@Configuration
@Profile({"dummy-input", "dummy-all"})
public class DummyDataProviderConfig {

    private static final Logger LOG = LoggerFactory.getLogger(DummyDataProviderConfig.class);

    @Bean(initMethod = "init")
    public RandomDataProvider DataProvider(DataConsumer dataConsumer) {
        LOG.info("Creating RandomDataProvider");
        return new RandomDataProvider(dataConsumer);
    }
}
