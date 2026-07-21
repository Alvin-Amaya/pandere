import { WhereConditions, IncludeMap, IRepository, CreateInput, UpdateInput } from "@/domain/repository";

export interface IDataModel<T, TArgs = Record<string, unknown>> {
  findMany(args?: TArgs): Promise<T[]>;
  findUnique(args?: TArgs): Promise<T | null>;
  create(args: { data: CreateInput<T> }): Promise<T>;
  update(args: { where: { id: number }; data: UpdateInput<T> }): Promise<T>;
  delete(args: { where: { id: number } }): Promise<T | void>;
}

export class Repository<T> implements IRepository<T> {
  constructor(protected model: IDataModel<T>) { }

  async findById(id: number, include?: Record<string, boolean | IncludeMap>): Promise<T | null> {
    return await this.model.findUnique({ where: { id }, include });
  }

  async getAll(include?: IncludeMap): Promise<T[]> {
    return await this.model.findMany({ include });
  }

  async create(item: CreateInput<T>): Promise<T> {
    return await this.model.create({ data: item });
  }

  async update(id: number, item: UpdateInput<T>): Promise<T> {
    return await this.model.update({
      where: { id },
      data: item,
    });
  }

  async delete(id: number): Promise<void> {
    await this.model.delete({ where: { id } });
  }
}