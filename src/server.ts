/*
  Copyright 2023 DoorDash, Inc.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
*/

import bodyParser from 'body-parser'
import express from 'express'
import { SendMessageCommand, SQSClient } from '@aws-sdk/client-sqs'
import { DataSource } from 'typeorm'
import { typeormConfig } from './ormconfig'
import { NoteEntity } from './entities/Note'

const PORT = 8080
const HOST = '0.0.0.0'

const app = express()

export const sqsClient = new SQSClient({
  region: process.env.AWS_REGION,
  endpoint: 'http://localstack:4566',
})

app.use(bodyParser.json())

async function startServer() {
  const AppDataSource = await new DataSource(typeormConfig).initialize()
  const notesRepository = AppDataSource.getRepository(NoteEntity)

  if (!process.env.SQS_NOTES_QUEUE_URL) {
    throw new Error('SQS notes queue url is not defined')
  }

  app.post('/notes', async (req, res) => {
    const createdNote = await notesRepository.save({
      contents: req.body.contents,
    })

    const sqsMessage = new SendMessageCommand({
      MessageBody: JSON.stringify({
        id: createdNote.id,
        contents: createdNote.contents,
      }),
      QueueUrl: process.env.SQS_NOTES_QUEUE_URL,
    })
    await sqsClient.send(sqsMessage)

    res.status(201).json(createdNote.id)
  })

  app.get('/notes/:noteId', async (req, res) => {
    const note = await notesRepository.findOneBy({
      id: req.params.noteId,
    })
    res.status(200).json(note)
  })

  app.listen(PORT, HOST)
  console.log(`Running on http://${HOST}:${PORT}`)
}

startServer()
