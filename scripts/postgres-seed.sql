-- Copyright 2023 DoorDash, Inc.

-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at

--     http://www.apache.org/licenses/LICENSE-2.0

-- Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

-- Add any commands you want to run on DB startup here.
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS notes (
  id         UUID NOT NULL DEFAULT uuid_generate_v4(),
  contents   varchar(450) NOT NULL,
  created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
);

SELECT * FROM pg_catalog.pg_tables WHERE schemaname != 'pg_catalog' AND schemaname != 'information_schema';

-- Since data is kept between container restarts, you probably want to delete old inserted data so that you have a known state everytime the the database starts up
DELETE FROM notes;

INSERT INTO notes (id, contents) VALUES ('6a71ff7e-577e-4991-bc70-4745b7fbbb78', 'Look at this lovely note!');
