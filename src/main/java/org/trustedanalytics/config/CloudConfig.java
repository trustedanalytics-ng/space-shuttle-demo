/**
 * Copyright (c) 2015 Intel Corporation
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
import org.springframework.cloud.Cloud;
import org.springframework.cloud.CloudException;
import org.springframework.cloud.CloudFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.trustedanalytics.exceptions.CloudConnectorNotDefinedException;

@Configuration
@Profile("cloud")
public class CloudConfig {

    private static final Logger LOG = LoggerFactory.getLogger(CloudConfig.class);

    @Bean
    public Cloud cloud() {
        try {
            CloudFactory factory = new CloudFactory();
            return factory.getCloud();
        } catch (CloudException e) {
            throw new CloudConnectorNotDefinedException("CloudConnector for cloud environment not found in classpath.", e);
        }
    }
}
