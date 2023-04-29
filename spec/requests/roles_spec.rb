require 'swagger_helper'

RSpec.describe 'roles', type: :request do

  # Path: \roles
  path '/roles' do
    # GET ALL METHOD
    get('list roles') do
      # Gather all the tags
      tags 'Roles'
      produces 'application/json'
      # Response 200
      response(200, 'successful') do
      schema type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  name: { type: :string, enum: ['user', 'admin', 'guest'] },
                },
                required: ['id', 'name'],
              }

        let!(:user) { Role.create(name: 'user') }
        let!(:admin) { Role.create(name: 'admin') }
      run_test!
      end
      
      after do |example|
        example.metadata[:response][:content] = {
          'application/json' => {
            example: JSON.parse(response.body, symbolize_names: true)
          }
        }
      end
    end

    # POST METHOD
    post('create role') do
      # Gather all the tags
      tags 'Roles'
      consumes 'application/json'
      produces 'application/json'
      # Response 200
      response(200, 'successful') do
        parameter name: :role, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: 'Not to say' }
        },
          required: [ 'name' ]
        }
        run_test!
      end
      # Response 201
      response '201', 'Student created successfully' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string, enum: ['Male', 'Female'] },
          },
          required: ['name' ]

          let(:role) { { id:0, name: 'Male' } }
          run_test!
      end
      # Response 422
      response '422', 'Invalid request parameters' do
        schema type: :object,
          properties: {
            errors: { type: :array, items: { type: :string } }
          },
          required: [ 'errors' ]

        let(:role) { { id: '', role: '' } }
        run_test!
      end

      after do |example|
        example.metadata[:response][:content] = {
          'application/json' => {
            example: JSON.parse(response.body, symbolize_names: true)
          }
        }
      end
        
    end
  end

  # Path: \roles\{id}
  path '/roles/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'
    # GET METHOD
    get('show role') do
      tags 'Roles'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, description: 'ID of the role'
      # Response 404
      response '404', 'Not Found' do
        schema type: :object,
          properties: {
            message: { type: :string },
          },
          required: ['message']

        let(:id) { -1 } # An ID that does not exist
        run_test!
      end
      # Response 200
      response(200, 'successful') do
        schema type: :object,
        properties: {
        id: { type: :integer },
        name: { type: :string, enum: ['Male', 'Female'] },
        }
        let(:role) { { id:0, name: 'Male' } }

          after do |example|
            example.metadata[:response][:content] = {
              'application/json' => {
                example: JSON.parse(response.body, symbolize_names: true)
              }
            }
          end
          run_test!
      end
    end

    # PATCH METHOD
    patch('update role') do
      # Gather all the tags
        tags 'Roles'
        consumes 'application/json'
        produces 'application/json'
        parameter name: :id, in: :path, type: :integer, description: 'ID of the role'
        parameter name: :role, in: :body, schema: {
          type: :object,
          properties: {
          name: { type: :string, example: 'New name' },
          },
          required: ['name'],
        }
        # Response 200
        response(200, 'successful') do
          schema type: :object,
          properties: {
          id: { type: :integer },
          name: { type: :string, enum: ['Male', 'Female', 'Not to say', 'New name'] },
          },
          required: ['id', 'name']
          let(:role) { Gender.create(name: 'Male') }
          let(:id) { role.id }
          let(:name) { 'New name' }
          run_test!
        end
        # Response 404
        response '404', 'Not Found' do
          schema type: :object,
            properties: {
              message: { type: :string },
            },
            required: ['message']

          let(:id) { -1 } # An ID that does not exist
          let(:name) { 'New name' }
          run_test!
        end
        # Response 422
        response '422', 'Unprocessable Entity' do
          schema type: :object,
            properties: {
              errors: { type: :array, items: { type: :string } },
            },
            required: ['errors']

          let(:role) { Gender.create(name: 'Male') }
          let(:id) { role.id }
          let(:name) { '' } # An empty name
          run_test!
        end

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end  
    end

    # DELETE METHOD
    delete('delete role') do
      tags 'Roles'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, description: 'ID of the role'

      # Response 204
        response '404', 'Not Found' do
          schema type: :object,
          properties: {
            message: { type: :string },
          },
          required: ['message']

          let(:id) { -1 } # An ID that does not exist
          run_test!
        end
      # Response 200
      response(200, 'successful') do
        schema type: :object,
        properties: {
        id: { type: :integer },
        name: { type: :string, enum: ['Male', 'Female', 'Not to say', 'New name'] },
        },
        required: ['id', 'name']

        let(:role) { Gender.create(name: 'Male') }
        let(:id) { role.id }
        let(:name) { 'New name' }
        run_test!
      end

       after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
      end
    end

  end

end
