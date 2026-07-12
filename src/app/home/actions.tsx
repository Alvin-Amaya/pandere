'use server'

import { projects } from "@/domain/app";

export async function getProjects() {
    return projects.getAll();
}

